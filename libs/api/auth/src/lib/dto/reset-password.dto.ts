import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, Matches, MinLength } from 'class-validator';

export class ResetPasswordDto {
  @ApiProperty({
    description: 'Password reset token',
    example: 'a1b2c3d4e5f6...',
  })
  @IsNotEmpty()
  @IsString()
  token: string;

  @ApiProperty({
    description: 'New password',
    example: 'NewPassword123!',
  })
  @IsNotEmpty()
  @IsString()
  @MinLength(8)
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'Password too weak - must contain uppercase, lowercase, and numbers/special characters',
  })
  password: string;
}
