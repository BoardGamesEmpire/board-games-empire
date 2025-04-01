import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class OidcCallbackDto {
  @ApiProperty({
    description: 'OIDC state parameter',
    example: 'a1b2c3d4e5f6...',
  })
  @IsNotEmpty()
  @IsString()
  state: string;

  @ApiProperty({
    description: 'OIDC authorization code',
    example: 'a1b2c3d4e5f6...',
  })
  @IsNotEmpty()
  @IsString()
  code: string;

  @ApiProperty({
    description: 'Error message from OIDC provider',
    required: false,
    example: 'access_denied',
  })
  @IsOptional()
  @IsString()
  error?: string;

  @ApiProperty({
    description: 'Error description from OIDC provider',
    required: false,
    example: 'The user denied the request',
  })
  @IsOptional()
  @IsString()
  error_description?: string;
}
