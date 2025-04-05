import { ApiProperty } from '@nestjs/swagger';
import { AuthStrategy } from '@prisma/client';
import { IsBoolean, IsEmail, IsEnum, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';

export class CreateUserDto {
  @ApiProperty({
    description: 'Username',
    example: 'CleverUserName',
  })
  @IsNotEmpty()
  @IsString()
  @MinLength(3)
  username: string;

  @ApiProperty({
    description: 'Email address',
    example: 'john.doe@example.com',
  })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'Password (optional for external users)',
    example: 'Password123!',
    required: false,
  })
  @IsOptional()
  @IsString()
  @MinLength(8)
  password?: string;

  @ApiProperty({
    description: 'First name',
    example: 'John',
    required: false,
  })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiProperty({
    description: 'Last name',
    example: 'Doe',
    required: false,
  })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiProperty({
    description: 'Avatar URL',
    example: 'https://example.com/avatar.jpg',
    required: false,
  })
  @IsOptional()
  @IsString()
  avatar?: string;

  @ApiProperty({
    description: 'Authentication strategy',
    enum: AuthStrategy,
    default: AuthStrategy.Local,
    required: false,
  })
  @IsOptional()
  @IsEnum(AuthStrategy)
  authStrategy?: AuthStrategy;

  @ApiProperty({
    description: 'Whether user was created via external provider',
    default: false,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  isExternalUser?: boolean;

  @ApiProperty({
    description: 'Whether email is verified',
    default: false,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  emailVerified?: boolean;
}
