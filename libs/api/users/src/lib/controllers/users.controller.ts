import { CurrentUser, JwtAuthGuard, Roles, RolesGuard } from '@bg-empire/api/auth';
import {
  Body,
  Controller,
  Delete,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ChangePasswordDto } from '../dto/change-password.dto';
import { CreateUserDto } from '../dto/create-user.dto';
import { FindUsersDto } from '../dto/find-users.dto';
import { UpdateUserPreferencesDto } from '../dto/update-user-preferences.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { UserPreferencesService } from '../services/user-preferences.service';
import { UsersService } from '../services/users.service';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly userPreferencesService: UserPreferencesService,
  ) {}

  @ApiOperation({ summary: 'Create a new user (Admin only)' })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'User created successfully',
  })
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin')
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @ApiOperation({ summary: 'Get all users (Admin only)' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Returns all users',
  })
  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin')
  findAll(@Query() query: FindUsersDto) {
    return this.usersService.findAll(query);
  }

  @ApiOperation({ summary: 'Get user by ID' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Returns the user',
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'User not found',
  })
  @Get(':id')
  @UseGuards(JwtAuthGuard)
  async findOne(@Param('id') id: string, @CurrentUser() currentUser: any) {
    // Check if user is requesting their own profile or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException('You are not authorized to view this user');
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    const user = await this.usersService.findOne(userId);
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return user;
  }

  @ApiOperation({ summary: 'Update user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'User updated successfully',
  })
  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto, @CurrentUser() currentUser: any) {
    // Check if user is updating their own profile or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException('You are not authorized to update this user');
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    return this.usersService.update(userId, updateUserDto);
  }

  @ApiOperation({ summary: 'Delete user (Admin only or self)' })
  @ApiResponse({
    status: HttpStatus.NO_CONTENT,
    description: 'User deleted successfully',
  })
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @UseGuards(JwtAuthGuard)
  async remove(@Param('id') id: string, @CurrentUser() currentUser: any) {
    // Check if user is deleting their own account or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException('You are not authorized to delete this user');
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    await this.usersService.remove(userId);
  }

  @ApiOperation({ summary: 'Change user password' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Password changed successfully',
  })
  @Post(':id/change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(
    @Param('id') id: string,
    @Body() changePasswordDto: ChangePasswordDto,
    @CurrentUser() currentUser: any,
  ) {
    // Check if user is changing their own password or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException("You are not authorized to change this user's password");
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    return this.usersService.changePassword(userId, changePasswordDto);
  }

  @ApiOperation({ summary: 'Get user preferences' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Returns user preferences',
  })
  @Get(':id/preferences')
  @UseGuards(JwtAuthGuard)
  async getUserPreferences(@Param('id') id: string, @CurrentUser() currentUser: any) {
    // Check if user is requesting their own preferences or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException("You are not authorized to view this user's preferences");
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    return this.userPreferencesService.findByUserId(userId);
  }

  @ApiOperation({ summary: 'Update user preferences' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Preferences updated successfully',
  })
  @Patch(':id/preferences')
  @UseGuards(JwtAuthGuard)
  async updateUserPreferences(
    @Param('id') id: string,
    @Body() updatePreferencesDto: UpdateUserPreferencesDto,
    @CurrentUser() currentUser: any,
  ) {
    // Check if user is updating their own preferences or is an admin
    if (id !== 'me' && id !== currentUser.id && !currentUser.roles?.includes('Admin')) {
      throw new ForbiddenException("You are not authorized to update this user's preferences");
    }

    // Handle the 'me' special case
    const userId = id === 'me' ? currentUser.id : id;

    return this.userPreferencesService.update(userId, updatePreferencesDto);
  }
}
