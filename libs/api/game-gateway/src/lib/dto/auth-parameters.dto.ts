import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, IsUrl } from 'class-validator';

export class BaseAuthParameters {
  @ApiProperty({
    description: 'Description of what these credentials access',
    example: 'Production API access',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;
}

export class OAuthParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'OAuth client ID',
    example: 'client-id-123456',
  })
  @IsNotEmpty()
  @IsString()
  clientId: string;

  @ApiProperty({
    description: 'OAuth client secret',
    example: 'client-secret-abcdef',
  })
  @IsNotEmpty()
  @IsString()
  clientSecret: string;

  @ApiProperty({
    description: 'OAuth authorization URL',
    example: 'https://example.com/oauth/authorize',
  })
  @IsNotEmpty()
  @IsUrl()
  authorizationUrl: string;

  @ApiProperty({
    description: 'OAuth token URL',
    example: 'https://example.com/oauth/token',
  })
  @IsNotEmpty()
  @IsUrl()
  tokenUrl: string;

  @ApiProperty({
    description: 'OAuth redirect URI',
    example: 'https://myapp.com/callback',
  })
  @IsNotEmpty()
  @IsUrl()
  redirectUri: string;

  @ApiProperty({
    description: 'OAuth scopes',
    example: ['read', 'write'],
    required: false,
  })
  @IsOptional()
  @IsString({ each: true })
  scopes?: string[];
}

export class ApiKeyParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'API Key',
    example: 'api-key-xyz123',
  })
  @IsNotEmpty()
  @IsString()
  apiKey: string;

  @ApiProperty({
    description: 'API key header name',
    example: 'X-API-Key',
    required: false,
  })
  @IsOptional()
  @IsString()
  headerName?: string;

  @ApiProperty({
    description: 'API key query parameter name',
    example: 'api_key',
    required: false,
  })
  @IsOptional()
  @IsString()
  queryParamName?: string;
}

export class BasicAuthParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'Username',
    example: 'admin',
  })
  @IsNotEmpty()
  @IsString()
  username: string;

  @ApiProperty({
    description: 'Password',
    example: 'password123',
  })
  @IsNotEmpty()
  @IsString()
  password: string;
}

export class PSKParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'Pre-shared key',
    example: 'psk-secret-key-123',
  })
  @IsNotEmpty()
  @IsString()
  key: string;

  @ApiProperty({
    description: 'Key identifier',
    example: 'key-1',
    required: false,
  })
  @IsOptional()
  @IsString()
  keyId?: string;
}

export class JWTParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'JWT token',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsNotEmpty()
  @IsString()
  token: string;

  @ApiProperty({
    description: 'JWT secret (for token generation)',
    example: 'jwt-secret-key',
    required: false,
  })
  @IsOptional()
  @IsString()
  secret?: string;

  @ApiProperty({
    description: 'Header name for JWT',
    example: 'Authorization',
    required: false,
    default: 'Authorization',
  })
  @IsOptional()
  @IsString()
  headerName?: string;

  @ApiProperty({
    description: 'Header prefix for JWT',
    example: 'Bearer',
    required: false,
    default: 'Bearer',
  })
  @IsOptional()
  @IsString()
  headerPrefix?: string;
}

export class CertificateParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'Client certificate in PEM format',
    example: '-----BEGIN CERTIFICATE-----\nMIICZjCCAc+gAwIB...',
  })
  @IsNotEmpty()
  @IsString()
  clientCertificate: string;

  @ApiProperty({
    description: 'Client private key in PEM format',
    example: '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkq...',
  })
  @IsNotEmpty()
  @IsString()
  clientPrivateKey: string;

  @ApiProperty({
    description: 'Passphrase for the private key',
    example: 'passphrase123',
    required: false,
  })
  @IsOptional()
  @IsString()
  passphrase?: string;
}

export class HMACParameters extends BaseAuthParameters {
  @ApiProperty({
    description: 'Secret key for HMAC',
    example: 'hmac-secret-key',
  })
  @IsNotEmpty()
  @IsString()
  secretKey: string;

  @ApiProperty({
    description: 'HMAC algorithm',
    example: 'sha256',
    default: 'sha256',
  })
  @IsNotEmpty()
  @IsString()
  algorithm: string;
}
