import { ApiProperty } from '@nestjs/swagger';
import { AuthType } from '@prisma/client';

export class GameGatewayResponseDto {
  @ApiProperty({
    description: 'Unique identifier',
    example: '01H8XVKRWVJTP5ZB3BZ56X13VN',
  })
  id: string;

  @ApiProperty({
    description: 'Name of the game source gateway',
    example: 'BoardGameGeek',
  })
  name: string;

  @ApiProperty({
    description: 'Description of the game source gateway',
    example: 'BoardGameGeek API integration for game data',
  })
  description: string | null;

  @ApiProperty({
    description: 'Message context for the gateway',
    example: 'BGG data provider',
  })
  messageContext: string | null;

  @ApiProperty({
    description: 'URL to the gateway icon',
    example: 'https://example.com/bgg-icon.png',
  })
  iconUrl: string | null;

  @ApiProperty({
    description: 'URL to the gateway logo',
    example: 'https://example.com/bgg-logo.png',
  })
  logoUrl: string | null;

  @ApiProperty({
    description: 'Website URL of the gateway',
    example: 'https://boardgamegeek.com',
  })
  websiteUrl: string | null;

  @ApiProperty({
    description: 'Base URL for the API',
    example: 'https://api.boardgamegeek.com/v2',
  })
  baseUrl: string | null;

  @ApiProperty({
    description: 'URL to API documentation',
    example: 'https://boardgamegeek.com/wiki/page/BGG_XML_API2',
  })
  apiDocumentation: string | null;

  @ApiProperty({
    description: 'API version',
    example: '2.0',
  })
  apiVersion: string | null;

  @ApiProperty({
    description: 'Whether this gateway is enabled',
    example: true,
  })
  enabled: boolean;

  @ApiProperty({
    description: 'Authentication type',
    enum: AuthType,
    example: AuthType.ApiKey,
  })
  authType: AuthType;

  @ApiProperty({
    description: 'Usage count of this gateway',
    example: 42,
  })
  usageCount: number;

  @ApiProperty({
    description: 'Last time the gateway was used',
    example: '2023-09-15T14:30:00Z',
  })
  lastUsed: Date | null;

  @ApiProperty({
    description: 'ID of the user who created this gateway',
    example: '01H8XVKRWVJTP5ZB3BZ56X13VN',
  })
  createdById: string | null;

  @ApiProperty({
    description: 'Creation timestamp',
    example: '2023-09-01T12:00:00Z',
  })
  createdAt: Date;

  @ApiProperty({
    description: 'Last update timestamp',
    example: '2023-09-15T14:30:00Z',
  })
  updatedAt: Date;
}
