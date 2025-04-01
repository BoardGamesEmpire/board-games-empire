import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class ForgotPasswordDto {
  @ApiProperty({
    description: 'Email address',
    example: 'john.doe@example.com',
  })
  @IsNotEmpty()
  @IsEmail()
  email: string;
}
