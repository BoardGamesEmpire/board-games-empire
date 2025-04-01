import { PrismaService } from '@bg-empire/api/prisma';
import { BadRequestException, ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService as NestJwtService } from '@nestjs/jwt';
import { compare, hash } from 'bcrypt';
import { randomBytes } from 'crypto';
import { DateTime } from 'luxon';
import { RegisterDto } from '../dto/register.dto';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService, private jwtService: NestJwtService) {}

  /**
   * Validate user credentials
   */
  async validateUser(username: string, password: string): Promise<any> {
    // Try to find user by username or email
    const user = await this.prisma.user.findFirst({
      where: {
        OR: [
          { username },
          { email: username }, // Allow login with email
        ],
      },
    });

    if (!user) {
      return null;
    }

    // If user doesn't have a password (OIDC user), validation fails
    if (!user.password) {
      return null;
    }

    // Verify password
    const isPasswordValid = await compare(password, user.password);
    if (!isPasswordValid) {
      return null;
    }

    // Update last login timestamp
    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLogin: new Date() },
    });

    // Return user without password
    const { password: _, ...result } = user;
    return result;
  }

  /**
   * Login user and generate tokens
   */
  async login(user: any) {
    // Generate access token payload
    const payload = {
      sub: user.id,
      username: user.username,
      email: user.email,
    };

    // Generate refresh token
    const refreshToken = randomBytes(40).toString('hex');
    const refreshTokenExpiry = DateTime.now().plus({ days: 30 }).toJSDate();

    // Store refresh token
    await this.prisma.token.create({
      data: {
        userId: user.id,
        token: refreshToken,
        expiresAt: refreshTokenExpiry,
      },
    });

    return {
      access_token: this.jwtService.sign(payload),
      refresh_token: refreshToken,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      },
    };
  }

  /**
   * Register a new user
   */
  async register(registerDto: RegisterDto) {
    // Check if username already exists
    const existingUsername = await this.prisma.user.findUnique({
      where: { username: registerDto.username },
    });

    if (existingUsername) {
      throw new ConflictException('Username already exists');
    }

    // Check if email already exists
    const existingEmail = await this.prisma.user.findUnique({
      where: { email: registerDto.email },
    });

    if (existingEmail) {
      throw new ConflictException('Email already in use');
    }

    // Hash password
    const hashedPassword = await hash(registerDto.password, 12);

    try {
      // Create user
      const user = await this.prisma.user.create({
        data: {
          username: registerDto.username,
          email: registerDto.email,
          password: hashedPassword,
          firstName: registerDto.firstName,
          lastName: registerDto.lastName,
          authStrategy: 'Local',
        },
      });

      // Generate email verification token
      const verificationToken = randomBytes(32).toString('hex');
      const tokenExpiry = DateTime.now().plus({ days: 1 }).toJSDate();

      // Store verification token
      await this.prisma.user.update({
        where: { id: user.id },
        data: {
          emailVerificationToken: verificationToken,
          emailVerificationTokenExpires: tokenExpiry,
        },
      });

      // TODO: Send verification email

      // Return user without password
      const { password: __, ...result } = user;
      return {
        message: 'User registered successfully. Please verify your email.',
        user: result,
      };
    } catch (error) {
      throw new BadRequestException('Could not create user');
    }
  }

  /**
   * Refresh access token using refresh token
   */
  async refreshToken(refreshToken: string) {
    // Find the refresh token
    const tokenRecord = await this.prisma.token.findUnique({
      where: { token: refreshToken },
      include: { User: true },
    });

    // Check if token exists and is valid
    if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    // Generate new access token
    const payload = {
      sub: tokenRecord.User.id,
      username: tokenRecord.User.username,
      email: tokenRecord.User.email,
    };

    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  /**
   * Log out user by invalidating refresh tokens
   */
  async logout(userId: string) {
    // Delete all refresh tokens for the user
    await this.prisma.token.deleteMany({
      where: { userId },
    });

    return { message: 'Logout successful' };
  }

  /**
   * Verify email with verification token
   */
  async verifyEmail(token: string) {
    // Find user with the verification token
    const user = await this.prisma.user.findFirst({
      where: {
        emailVerificationToken: token,
        emailVerificationTokenExpires: {
          gt: new Date(),
        },
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid or expired verification token');
    }

    // Update user as verified
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        emailVerified: true,
        emailVerificationToken: null,
        emailVerificationTokenExpires: null,
      },
    });

    return { message: 'Email verified successfully' };
  }

  /**
   * Request password reset
   */
  async requestPasswordReset(email: string) {
    // Check if system allows password resets
    const systemSettings = await this.prisma.systemSetting.findFirst();
    if (systemSettings && !systemSettings.allowPasswordResets) {
      throw new BadRequestException('Password resets are disabled');
    }

    // Find user by email
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      // For security reasons, don't reveal if the email exists or not
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // Generate password reset token
    const resetToken = randomBytes(32).toString('hex');
    const tokenExpiry = new Date();
    tokenExpiry.setHours(tokenExpiry.getHours() + 1); // 1 hour

    // Store reset token
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        passwordResetToken: resetToken,
        passwordResetTokenExpires: tokenExpiry,
      },
    });

    // TODO: Send password reset email

    return { message: 'If the email exists, a reset link has been sent' };
  }

  /**
   * Reset password using reset token
   */
  async resetPassword(token: string, newPassword: string) {
    // Find user with the reset token
    const user = await this.prisma.user.findFirst({
      where: {
        passwordResetToken: token,
        passwordResetTokenExpires: {
          gt: new Date(),
        },
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid or expired reset token');
    }

    // Hash new password
    const hashedPassword = await hash(newPassword, 12);

    // Update user's password
    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        passwordResetToken: null,
        passwordResetTokenExpires: null,
        lastPasswordChange: new Date(),
      },
    });

    // Delete all refresh tokens for the user
    await this.prisma.token.deleteMany({
      where: { userId: user.id },
    });

    return { message: 'Password reset successful' };
  }
}
