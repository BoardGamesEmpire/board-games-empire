import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsBoolean, IsNotEmpty, IsOptional, IsString, IsUrl } from 'class-validator';

export class CreateIdentityProviderDto {
  @ApiProperty({
    description: 'Display name for the identity provider',
    example: 'Google',
  })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({
    description: 'Provider identifier (lowercase, no spaces)',
    example: 'google',
  })
  @IsNotEmpty()
  @IsString()
  provider: string;

  @ApiProperty({
    description: 'Client ID from the provider',
    example: 'your-client-id',
  })
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @ApiProperty({
    description: 'Client secret from the provider',
    example: 'your-client-secret',
  })
  @IsNotEmpty()
  @IsString()
  clientSecret: string;

  @ApiProperty({
    description: 'OIDC discovery URL',
    required: false,
    example: 'https://accounts.google.com/.well-known/openid-configuration',
  })
  @IsOptional()
  @IsUrl()
  discoveryUrl?: string;

  @ApiProperty({
    description: 'Authorization endpoint URL',
    required: false,
    example: 'https://accounts.google.com/o/oauth2/v2/auth',
  })
  @IsOptional()
  @IsUrl()
  authorizationUrl?: string;

  @ApiProperty({
    description: 'Token endpoint URL',
    required: false,
    example: 'https://oauth2.googleapis.com/token',
  })
  @IsOptional()
  @IsUrl()
  tokenUrl?: string;

  @ApiProperty({
    description: 'UserInfo endpoint URL',
    required: false,
    example: 'https://openidconnect.googleapis.com/v1/userinfo',
  })
  @IsOptional()
  @IsUrl()
  userInfoUrl?: string;

  @ApiProperty({
    description: 'JWKS endpoint URL',
    required: false,
    example: 'https://www.googleapis.com/oauth2/v3/certs',
  })
  @IsOptional()
  @IsUrl()
  jwksUrl?: string;

  @ApiProperty({
    description: 'OAuth scopes to request',
    required: false,
    example: ['openid', 'email', 'profile'],
    default: ['openid', 'email', 'profile'],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  scopes?: string[];

  @ApiProperty({
    description: 'Whether this provider is enabled',
    required: false,
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  enabled?: boolean;
}
