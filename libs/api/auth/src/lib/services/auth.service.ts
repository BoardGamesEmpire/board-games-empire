import { PrismaService } from '@bg-empire/api-prisma';
import { BadRequestException, ConflictException, Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { JwtService as NestJwtService } from '@nestjs/jwt';
import cuid2 from '@paralleldrive/cuid2';
import { AuthStrategy, TokenType, User } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { DateTime } from 'luxon';
import * as crypto from 'node:crypto';
import { LoginDto } from '../dto/login.dto';
import type { RegisterDto } from '../dto/register.dto';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService, private jwtService: NestJwtService) {}

  /**
   * Validate user credentials
   */
  async validateUser(email: string, password: string): Promise<User | null> {
    console.log('validating user', email, password);
    const auth = await this.prisma.userAuthentication.findFirst({
      where: { email },
      include: { user: true },
    });

    if (!auth) {
      Logger.warn(`No authentication found for email: ${email}`);

      return null;
    }

    if (auth.accountLocked) {
      Logger.warn(`Account is locked for email: ${email}`);

      await this.increaseFailedLoginAttempts(auth.id);

      return null;
    }

    // If user doesn't have a password (OIDC user), validation fails
    if (!auth.password) {
      Logger.warn(`No password found for email: ${email}`);

      await this.increaseFailedLoginAttempts(auth.id);

      return null;
    }

    const isPasswordValid = await bcrypt.compare(password, auth.password);
    if (!isPasswordValid) {
      Logger.warn(`Invalid password for email: ${email}`);

      await this.increaseFailedLoginAttempts(auth.id);
      return null;
    }

    await this.prisma.userAuthentication.update({
      where: { id: auth.id },
      data: { lastLogin: new Date() },
    });

    return auth.user;
  }

  /**
   * Login user and generate tokens
   */
  async login(user: User, loginDTO: LoginDto, ipAddress?: string, userAgent?: string) {
    const auth = await this.prisma.userAuthentication.findUnique({
      where: { userId: user.id },
      select: {
        email: true,
        id: true,
      },
    });

    if (!auth) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const sessionId = cuid2.createId();
    const payload = {
      sub: user.id,
      username: user.username,
      email: auth.email,
      sid: sessionId,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = crypto.randomBytes(40).toString('hex');

    const rememberMe = loginDTO.rememberMe || false;

    const accessTokenExpiry = DateTime.now().plus({ hours: 1 }).toJSDate();
    const refreshTokenExpiry = DateTime.now()
      .plus({
        days: rememberMe ? 30 : 1,
      })
      .toJSDate();
    const sessionExpiry = refreshTokenExpiry;

    const deviceInfo = this.extractDeviceInfo(userAgent);

    try {
      await this.prisma.$transaction(async (tx) => {
        const session = await tx.userSession.create({
          data: {
            id: sessionId,
            authenticationId: auth.id,
            token: accessToken,
            ipAddress,
            deviceInfo: {
              ...deviceInfo,
              ...loginDTO.deviceInfo,
            },
            userAgent,
            expiresAt: sessionExpiry,
          },
          select: {
            id: true,
          },
        });

        await tx.token.createMany({
          data: [
            {
              authenticationId: auth.id,
              token: accessToken,
              type: TokenType.Access,
              expiresAt: accessTokenExpiry,
            },
            {
              authenticationId: auth.id,
              token: refreshToken,
              type: TokenType.Refresh,
              expiresAt: refreshTokenExpiry,
              metadata: {
                session_id: session.id,
              },
            },
          ],
        });

        await tx.userLoginHistory.create({
          data: {
            authenticationId: auth.id,
            ipAddress,
            userAgent,
            success: true,
          },
        });

        await tx.userAuthentication.update({
          where: { id: auth.id },
          data: {
            lastLogin: new Date(),
            failedLoginAttempts: 0,
          },
        });
      });
    } catch (error) {
      Logger.error('Error creating session or tokens:', error);
      throw error;
    }

    Logger.log(`User ${user.username} logged in successfully`);

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
      user: {
        id: user.id,
        username: user.username,
        email: auth.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      },
    };
  }

  private async increaseFailedLoginAttempts(authId: string, ipAddress?: string, userAgent?: string) {
    const auth = await this.prisma.userAuthentication.update({
      where: { id: authId },
      data: {
        lastFailedLogin: new Date(),
        failedLoginAttempts: {
          increment: 1,
        },
        loginHistory: {
          create: {
            ipAddress,
            userAgent,
            success: false,
          },
        },
      },

      select: {
        failedLoginAttempts: true,
        accountLocked: true,
      },
    });

    // TODO: failed login attempts threshold should be configurable
    if (auth.failedLoginAttempts >= 5) {
      await this.prisma.userAuthentication.update({
        where: { id: authId },
        data: {
          accountLocked: true,
        },
      });
    }

    return auth;
  }

  /**
   * Extract device info from user agent
   */
  private extractDeviceInfo(userAgent?: string): Record<string, any> {
    if (!userAgent) return {};

    // Basic extraction - could use a more sophisticated library like ua-parser-js
    const browser = userAgent.match(/(?:MSIE|Firefox|Chrome|Safari|Opera)[\s\\/]\d+/)?.[0] || 'Unknown Browser';
    const os = userAgent.match(/(?:Windows|Linux|Mac OS|Android|iOS)[\s\\/][^;)]*/)?.[0] || 'Unknown OS';

    return {
      browser,
      os,
      userAgent: userAgent.substring(0, 255),
    };
  }

  /**
   * Register a new user. Create user and authentication records.
   */
  async register(registerDto: RegisterDto) {
    const existingUsername = await this.prisma.user.findUnique({
      where: { username: registerDto.username },
      select: { id: true },
    });

    if (existingUsername) {
      throw new ConflictException('Username already exists');
    }

    const existingEmail = await this.prisma.userAuthentication.findUnique({
      where: { email: registerDto.email },
      select: { id: true },
    });

    if (existingEmail) {
      throw new ConflictException('Email already in use');
    }

    const usersCount = await this.prisma.user.count();
    const isSiteOwner = usersCount === 0;

    const hashedPassword = await bcrypt.hash(registerDto.password, 12);

    try {
      const verificationToken = crypto.randomBytes(32).toString('hex');
      const tokenExpiry = DateTime.now().plus({ days: 1 }).toJSDate();

      const roleName = isSiteOwner ? 'System Administrator' : 'User';
      const role = await this.prisma.role.findUnique({
        where: { name: roleName },
        select: { id: true },
      });

      if (!role) {
        throw new ConflictException('Role not found');
      }

      let user;
      await this.prisma.$transaction(async (tx) => {
        const createdUser = await tx.user.create({
          data: {
            username: registerDto.username,
            firstName: registerDto.firstName,
            lastName: registerDto.lastName,
            authentication: {
              create: {
                authStrategy: AuthStrategy.Local,
                email: registerDto.email,
                password: hashedPassword,
                lastLogin: new Date(),
                emailVerified: false,

                tokens: {
                  create: {
                    token: verificationToken,
                    type: TokenType.EmailVerification,
                    expiresAt: tokenExpiry,
                  },
                },
              },
            },
            preferences: {
              create: {},
            },
            roles: {
              create: {
                roleId: role.id,
              },
            },
          },
          include: {
            authentication: {
              select: {
                id: true,
              },
            },
          },
        });

        user = createdUser;
      });

      // TODO: Send verification email
      // TODO: Login?

      return {
        message: 'User registered successfully. Please verify your email.',
        user,
      };
    } catch (error) {
      Logger.error('Error creating user:', error);
      throw new BadRequestException('Could not create user');
    }
  }

  /**
   * Refresh access token using refresh token
   */
  async refreshToken(refreshToken: string) {
    const tokenRecord = await this.prisma.token.findUnique({
      where: { token: refreshToken, type: TokenType.Refresh },
      include: {
        authentication: {
          select: {
            userId: true,
            email: true,
          },
          include: {
            user: {
              select: {
                id: true,
                username: true,
              },
            },
          },
        },
      },
    });

    if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    if (tokenRecord.isRevoked) {
      throw new UnauthorizedException('Refresh token has been revoked');
    }

    const sessionId = (<{ sessionId?: string }>tokenRecord.metadata)?.sessionId;
    if (sessionId) {
      const session = await this.prisma.userSession.findFirst({
        where: {
          id: sessionId,
          isValid: true,
          expiresAt: { gt: new Date() },
        },
      });

      if (!session) {
        throw new UnauthorizedException('Session is invalid or expired');
      }

      await this.prisma.userSession.update({
        where: { id: sessionId },
        data: { lastActive: new Date() },
      });
    }

    const payload = {
      sub: tokenRecord.authentication.userId,
      username: tokenRecord.authentication.user.username,
      email: tokenRecord.authentication.email,
      sid: sessionId,
    };

    const accessToken = this.jwtService.sign(payload);
    const accessTokenExpiry = DateTime.now().plus({ hours: 1 }).toJSDate();

    await this.prisma.token.create({
      data: {
        authenticationId: tokenRecord.authenticationId,
        token: accessToken,
        type: TokenType.Access,
        expiresAt: accessTokenExpiry,
      },
    });

    return {
      access_token: accessToken,
    };
  }

  /**
   * Log out user by invalidating sessions and refresh tokens
   */
  async logout(userId: string, sessionId?: string, allSessions = false) {
    const auth = await this.prisma.userAuthentication.findUnique({
      where: { userId },
      select: { id: true },
    });

    if (!auth) {
      throw new UnauthorizedException('User not found');
    }

    await this.prisma.$transaction(async (tx) => {
      if (allSessions) {
        await tx.userSession.updateMany({
          where: {
            authenticationId: auth.id,
            isValid: true,
          },
          data: {
            isValid: false,
          },
        });

        await tx.token.updateMany({
          where: {
            authenticationId: auth.id,
            type: TokenType.Refresh,
            isRevoked: false,
          },
          data: {
            isRevoked: true,
            revokedAt: new Date(),
            revocationReason: 'User logged out from all sessions',
          },
        });
      } else if (sessionId) {
        await tx.userSession.updateMany({
          where: {
            id: sessionId,
            authenticationId: auth.id,
            isValid: true,
          },
          data: {
            isValid: false,
          },
        });

        await tx.token.updateMany({
          where: {
            authenticationId: auth.id,
            type: TokenType.Refresh,
            isRevoked: false,
            metadata: {
              path: ['session_id'],
              equals: sessionId,
            },
          },
          data: {
            isRevoked: true,
            revokedAt: new Date(),
          },
        });
      } else {
        throw new BadRequestException('Must provide sessionId or set allSessions to true');
      }
    });

    return { message: 'Logout successful' };
  }

  async getActiveSessions(userId: string) {
    const auth = await this.prisma.userAuthentication.findUnique({
      where: { userId },
      select: { id: true },
    });

    if (!auth) {
      throw new UnauthorizedException('User not found');
    }

    return this.prisma.userSession.findMany({
      where: {
        authenticationId: auth.id,
        isValid: true,
        expiresAt: { gt: new Date() },
      },
      select: {
        id: true,
        ipAddress: true,
        userAgent: true,
        // deviceInfo: true,
        createdAt: true,
        lastActive: true,
        expiresAt: true,
      },
      orderBy: { lastActive: 'desc' },
    });
  }

  /**
   * Verify email with verification token
   */
  async verifyEmail(token: string) {
    const tokenRecord = await this.prisma.token.findUnique({
      where: { token, type: TokenType.EmailVerification },
      include: {
        authentication: {
          select: {
            userId: true,
            emailVerified: true,
          },
        },
      },
    });

    if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired verification token');
    }

    if (tokenRecord.isRevoked) {
      throw new UnauthorizedException('Verification token has been revoked');
    }

    if (tokenRecord.isUsed) {
      throw new UnauthorizedException('Verification token has already been used');
    }

    // Mark token as used and email as verified
    await this.prisma.token.update({
      where: { id: tokenRecord.id },
      data: {
        isUsed: true,
        usedAt: new Date(),

        authentication: {
          update: {
            emailVerified: true,
          },
        },
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

    const auth = await this.prisma.userAuthentication.findFirst({
      where: { email },
      select: { id: true },
    });

    if (!auth) {
      // For security reasons, don't reveal if the email exists or not
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // Generate password reset token
    const resetToken = crypto.randomBytes(32).toString('hex');
    const tokenExpiry = DateTime.now().plus({ hours: 1 }).toJSDate();

    await this.prisma.token.create({
      data: {
        authenticationId: auth.id,
        token: resetToken,
        type: TokenType.PasswordReset,
        expiresAt: tokenExpiry,
      },
    });

    // TODO: Send password reset email

    return { message: 'If the email exists, a reset link has been sent' };
  }

  /**
   * Reset password using reset token
   */
  async resetPassword(token: string, newPassword: string) {
    const tokenRecord = await this.prisma.token.findUnique({
      where: { token, type: TokenType.PasswordReset },
      include: {
        authentication: {
          select: {
            userId: true,
          },
        },
      },
    });

    if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired reset token');
    }
    if (tokenRecord.isRevoked) {
      throw new UnauthorizedException('Reset token has been revoked');
    }
    if (tokenRecord.isUsed) {
      throw new UnauthorizedException('Reset token has already been used');
    }

    await this.prisma.token.update({
      where: {
        id: tokenRecord.id,
        type: TokenType.PasswordReset,
        isUsed: false,
      },
      data: {
        isUsed: true,
        usedAt: new Date(),
      },
    });

    const hashedPassword = await bcrypt.hash(newPassword, 12);

    await this.prisma.$transaction(async (tx) => {
      await tx.userAuthentication.update({
        where: { id: tokenRecord.authenticationId },
        data: {
          password: hashedPassword,
          lastPasswordChange: new Date(),
        },
      });

      await tx.userSession.updateMany({
        where: {
          authenticationId: tokenRecord.authenticationId,
          isValid: true,
        },
        data: {
          isValid: false,
        },
      });

      await tx.token.updateMany({
        where: {
          authenticationId: tokenRecord.authenticationId,
          type: TokenType.Refresh,
          isRevoked: false,
        },
        data: {
          isRevoked: true,
          revokedAt: new Date(),
          revocationReason: 'Password reset',
        },
      });
    });

    return { message: 'Password reset successful' };
  }
}
