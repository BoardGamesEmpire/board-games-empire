import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, IsString, Matches, MinLength } from 'class-validator';

export class RegisterDto {
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
    description: 'Password',
    example: 'Password123!',
  })
  @IsNotEmpty()
  @IsString()
  @MinLength(8)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'Password too weak - must contain uppercase, lowercase, and numbers/special characters',
  })
  password: string;

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
}
