import { AuthService } from '@bg-empire/api/auth';
import { PrismaService } from '@bg-empire/api/prisma';
import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthStrategy, Prisma } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import type { ChangePasswordDto } from '../dto/change-password.dto';
import type { CreateUserDto } from '../dto/create-user.dto';
import type { FindUsersDto } from '../dto/find-users.dto';
import type { UpdateUserDto } from '../dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService, private auth: AuthService) {}

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
    const existingEmail = await this.prisma.userAuthentication.findUnique({
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
        firstName: createUserDto.firstName,
        lastName: createUserDto.lastName,
        avatar: createUserDto.avatar,

        authentication: {
          create: {
            emailVerified: createUserDto.emailVerified || false,
            isExternalUser: createUserDto.isExternalUser || false,
            authStrategy: createUserDto.authStrategy || AuthStrategy.Local,
            email: createUserDto.email,
            password: hashedPassword,
          },
        },
      },
    });

    // Create default user preferences
    await this.prisma.userPreferences.create({
      data: {
        userId: user.id,
      },
    });

    return user;
  }

  /**
   * Find all users with pagination and filtering
   */
  async findAll(query: FindUsersDto) {
    const { page = 1, limit = 10, search, sortBy = 'createdAt', sortOrder = 'desc' } = query;
    const skip = (page - 1) * limit;

    // Build filter conditions
    let where: Prisma.UserWhereInput = {};
    if (search) {
      where = {
        OR: [
          { username: { contains: search, mode: 'insensitive' } },
          { authentication: { email: { contains: search, mode: 'insensitive' } } },
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
          firstName: true,
          lastName: true,
          avatar: true,
          createdAt: true,
          updatedAt: true,
          authentication: {
            select: {
              email: true,
              emailVerified: true,
              isExternalUser: true,
              authStrategy: true,
              lastLogin: true,
            },
          },
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
        firstName: true,
        lastName: true,
        avatar: true,
        bio: true,
        createdAt: true,
        updatedAt: true,

        // Include related data
        preferences: true,
        authentication: {
          select: {
            email: true,
            emailVerified: true,
            isExternalUser: true,
            authStrategy: true,
            lastLogin: true,

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
        OR: [
          {
            username: usernameOrEmail,
          },
          {
            authentication: {
              email: usernameOrEmail,
            },
          },
        ],
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
      include: {
        authentication: {
          select: {
            email: true,
            emailVerified: true,
            isExternalUser: true,
            authStrategy: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    const systemSettings = await this.prisma.systemSetting.findFirst({});

    // Check if username is being changed and is unique
    if (updateUserDto.username && updateUserDto.username !== user.username) {
      if (systemSettings.allowUsernameChange === false) {
        throw new BadRequestException('Username change is not allowed');
      }

      const existingUsername = await this.prisma.user.findUnique({
        where: { username: updateUserDto.username },
      });

      if (existingUsername) {
        throw new ConflictException('Username already exists');
      }
    }

    // Check if email is being changed and is unique
    if (updateUserDto.email && updateUserDto.email !== user.authentication.email) {
      const existingEmail = await this.prisma.userAuthentication.findUnique({
        where: { email: updateUserDto.email },
      });

      if (existingEmail) {
        throw new ConflictException('Email already in use');
      }
    }

    const { email, ...updates } = updateUserDto;
    if (email) {
      (<Prisma.UserUpdateInput>updates).authentication = {
        update: {
          email,
          emailVerified: false,
        },
      };
    }

    // Update the user
    const updatedUser = await this.prisma.user.update({
      where: { id },
      data: updates,
      select: {
        id: true,
        username: true,
        firstName: true,
        lastName: true,
        avatar: true,
        bio: true,
        createdAt: true,
        updatedAt: true,

        authentication: {
          select: {
            email: true,
            emailVerified: true,
            isExternalUser: true,
            authStrategy: true,
            lastLogin: true,
          },
        },
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
      include: {
        authentication: {
          select: {
            id: true,
            isExternalUser: true,
            password: true,
          },
        },
      },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // If external user without password, can't change password. For now...
    if (user.authentication.isExternalUser && !user.authentication.password) {
      throw new BadRequestException('External users without a password cannot change their password');
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(changePasswordDto.currentPassword, user.authentication.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    const hashedPassword = await bcrypt.hash(changePasswordDto.newPassword, 12);
    await this.prisma.userAuthentication.update({
      where: { id: user.authentication.id },
      data: {
        password: hashedPassword,
        lastPasswordChange: new Date(),
      },
    });

    return { message: 'Password changed successfully' };
  }
}
