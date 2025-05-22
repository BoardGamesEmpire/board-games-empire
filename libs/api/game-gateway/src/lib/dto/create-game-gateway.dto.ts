import { ApiProperty } from '@nestjs/swagger';
import { AuthType } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  IsUrl,
  ValidateIf,
  ValidateNested,
} from 'class-validator';

export class CreateGameGatewayDto {
  @ApiProperty({
    description: 'Name of the game gateway',
    example: 'BoardGameGeek',
  })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({
    description: 'Description of the game gateway',
    example: 'BoardGameGeek API integration for game data',
    required: false,
  })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    description: 'Message context for the gateway',
    example: 'BGG data provider',
    required: false,
  })
  @IsOptional()
  @IsString()
  messageContext?: string;

  @ApiProperty({
    description: 'URL to the gateway icon',
    example: 'https://example.com/bgg-icon.png',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  iconUrl?: string;

  @ApiProperty({
    description: 'URL to the gateway logo',
    example: 'https://example.com/bgg-logo.png',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  logoUrl?: string;

  @ApiProperty({
    description: 'Website URL of the gateway',
    example: 'https://boardgamegeek.com',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  websiteUrl?: string;

  @ApiProperty({
    description: 'Base URL for the API',
    example: 'https://api.boardgamegeek.com/v2',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  baseUrl?: string;

  @ApiProperty({
    description: 'URL to API documentation',
    example: 'https://boardgamegeek.com/wiki/page/BGG_XML_API2',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  apiDocumentation?: string;

  @ApiProperty({
    description: 'API version',
    example: '2.0',
    required: false,
  })
  @IsOptional()
  @IsString()
  apiVersion?: string;

  @ApiProperty({
    description: 'Whether this gateway is enabled',
    example: true,
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  enabled?: boolean = true;

  @ApiProperty({
    description: 'Authentication type',
    enum: AuthType,
    example: AuthType.ApiKey,
  })
  @IsEnum(AuthType)
  authType: AuthType;

  @ApiProperty({
    description: 'Authentication parameters based on the auth type',
    type: 'object',
    properties: {
      apiKey: {
        type: 'string',
        description: 'API key for authentication',
      },
      headerName: {
        type: 'string',
        description: 'Header name for the API key',
      },
    },
    example: {
      apiKey: 'xyz123',
      headerName: 'X-API-Key',
    },
  })
  @ValidateIf((o) => o.authType !== 'None')
  @IsObject()
  @ValidateNested()
  @Type(() => Object)
  authParameters?: any;
}
