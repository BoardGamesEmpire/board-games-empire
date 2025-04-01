import { PrismaService } from '@bg-empire/api/prisma';
import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import type { ChangePasswordDto } from '../dto/change-password.dto';
import type { CreateUserDto } from '../dto/create-user.dto';
import type { FindUsersDto } from '../dto/find-users.dto';
import type { UpdateUserDto } from '../dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Create a new user
   */
  async create(createUserDto: CreateUserDto) {
    // Check if username already exists
    const existingUsername = await this.prisma.user.findUnique({
      where: { username: createUserDto.username },
    });

    if (existingUsername) {
      throw new ConflictException('Username already exists');
    }

    // Check if email already exists
    const existingEmail = await this.prisma.user.findUnique({
      where: { email: createUserDto.email },
    });

    if (existingEmail) {
      throw new ConflictException('Email already in use');
    }

    // TODO: must be oidc strategy if password is empty
    let hashedPassword = null;
    if (createUserDto.password) {
      hashedPassword = await bcrypt.hash(createUserDto.password, 12);
    }

    // Create the user
    const user = await this.prisma.user.create({
      data: {
        username: createUserDto.username,
        email: createUserDto.email,
        password: hashedPassword,
        firstName: createUserDto.firstName,
        lastName: createUserDto.lastName,
        avatar: createUserDto.avatar,
        authStrategy: createUserDto.authStrategy || 'Local',
        isExternalUser: createUserDto.isExternalUser || false,
        emailVerified: createUserDto.emailVerified || false,
      },
    });

    // Create default user preferences
    await this.prisma.userPreferences.create({
      data: {
        userId: user.id,
      },
    });

    // Return user without password
    const { password: _, ...result } = user;
    return result;
  }

  /**
   * Find all users with pagination and filtering
   */
  async findAll(query: FindUsersDto) {
    const { page = 1, limit = 10, search, sortBy = 'createdAt', sortOrder = 'desc' } = query;
    const skip = (page - 1) * limit;

    // Build filter conditions
    let where = {};
    if (search) {
      where = {
        OR: [
          { username: { contains: search, mode: 'insensitive' } },
          { email: { contains: search, mode: 'insensitive' } },
          { firstName: { contains: search, mode: 'insensitive' } },
          { lastName: { contains: search, mode: 'insensitive' } },
        ],
      };
    }

    // Build sort options
    const validSortFields = ['username', 'email', 'createdAt', 'lastLogin'];
    const orderBy: Prisma.UserOrderByWithRelationInput = validSortFields.includes(sortBy)
      ? { [sortBy]: sortOrder }
      : { createdAt: 'desc' };

    // Execute query with pagination
    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        select: {
          id: true,
          username: true,
          email: true,
          firstName: true,
          lastName: true,
          avatar: true,
          authStrategy: true,
          isExternalUser: true,
          emailVerified: true,
          createdAt: true,
          updatedAt: true,
          lastLogin: true,
        },
        skip,
        take: limit,
        orderBy,
      }),
      this.prisma.user.count({ where }),
    ]);

    return {
      items: users,
      meta: {
        totalItems: total,
        itemCount: users.length,
        itemsPerPage: limit,
        totalPages: Math.ceil(total / limit),
        currentPage: page,
      },
    };
  }

  /**
   * Find one user by ID
   */
  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        username: true,
        email: true,
        firstName: true,
        lastName: true,
        avatar: true,
        bio: true,
        authStrategy: true,
        isExternalUser: true,
        emailVerified: true,
        createdAt: true,
        updatedAt: true,
        lastLogin: true,
        // Include related data
        preferences: true,
        externalIdentities: {
          select: {
            id: true,
            provider: {
              select: {
                id: true,
                name: true,
                provider: true,
              },
            },
            externalId: true,
            email: true,
            createdAt: true,
          },
        },
      },
    });

    if (!user) {
      return null;
    }

    return user;
  }

  /**
   * Find user by username or email
   */
  async findByUsernameOrEmail(usernameOrEmail: string) {
    return this.prisma.user.findFirst({
      where: {
        OR: [{ username: usernameOrEmail }, { email: usernameOrEmail }],
      },
    });
  }

  /**
   * Update a user
   */
  async update(id: string, updateUserDto: UpdateUserDto) {
    // Check if user exists
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // Check if username is being changed and is unique
    if (updateUserDto.username && updateUserDto.username !== user.username) {
      const existingUsername = await this.prisma.user.findUnique({
        where: { username: updateUserDto.username },
      });

      if (existingUsername) {
        throw new ConflictException('Username already exists');
      }
    }

    // Check if email is being changed and is unique
    if (updateUserDto.email && updateUserDto.email !== user.email) {
      const existingEmail = await this.prisma.user.findUnique({
        where: { email: updateUserDto.email },
      });

      if (existingEmail) {
        throw new ConflictException('Email already in use');
      }

      // If email is changed, mark as unverified
      updateUserDto.emailVerified = false;
    }

    // Update the user
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: updateUserDto,
      select: {
        id: true,
        username: true,
        email: true,
        firstName: true,
        lastName: true,
        avatar: true,
        bio: true,
        authStrategy: true,
        isExternalUser: true,
        emailVerified: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    return updatedUser;
  }

  /**
   * Remove a user
   */
  async remove(id: string) {
    // Check if user exists
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // Delete the user - cascading deletes should handle related records
    await this.prisma.user.delete({
      where: { id },
    });

    return { success: true };
  }

  /**
   * Change user password
   */
  async changePassword(id: string, changePasswordDto: ChangePasswordDto) {
    // Check if user exists
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // If external user without password, can't change password
    if (user.isExternalUser && !user.password) {
      throw new BadRequestException('External users without a password cannot change their password');
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(changePasswordDto.currentPassword, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    const hashedPassword = await bcrypt.hash(changePasswordDto.newPassword, 12);
    await this.prisma.user.update({
      where: { id },
      data: {
        password: hashedPassword,
        lastPasswordChange: new Date(),
      },
    });

    return { message: 'Password changed successfully' };
  }
}
