import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class UpdateUserDto {
  @ApiProperty({
    description: 'Username',
    example: 'NewCleverUserName',
    required: false,
  })
  @IsOptional()
  @IsString()
  @MinLength(3)
  username?: string;

  @ApiProperty({
    description: 'Email address',
    example: 'john.doe@example.com',
    required: false,
  })
  @IsOptional()
  @IsEmail()
  email?: string;

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
    description: 'Bio/about information',
    example: 'Board game enthusiast and collector',
    required: false,
  })
  @IsOptional()
  @IsString()
  bio?: string;

  @ApiProperty({
    description: 'Whether email is verified',
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  emailVerified?: boolean;
}
