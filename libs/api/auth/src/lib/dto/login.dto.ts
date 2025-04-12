import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsEmail, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';

export class LoginDto {
  @ApiProperty({
    description: 'User email',
    example: 'john.doe@example.com',
  })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'User password',
    example: 'Password123!',
    minLength: 8,
  })
  @IsNotEmpty()
  @IsString()
  @MinLength(8)
  password: string;

  @ApiProperty({
    description: 'Remember me option',
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  rememberMe?: boolean;

  @ApiProperty({
    description: 'Device information - Info dependant on the platform',
    example: {
      device: 'iPhone 13',
      os: 'iOS',
      browser: 'Safari',
      platform: 'Mobile',
      manufacturer: 'Apple',
      userAgent:
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
      appName: 'MyApp',
      appVersion: '1.0.0',
    },
  })
  @IsOptional()
  deviceInfo?: {
    device?: string;
    os?: string;
    browser?: string;
    platform?: string;
    manufacturer?: string;
    userAgent?: string;
    appName?: string;
    appVersion?: string;
  };
}
