import { ApiProperty } from '@nestjs/swagger';
import { Visibility } from '@prisma/client';
import { IsArray, IsBoolean, IsEnum, IsOptional, IsString, IsUUID } from 'class-validator';

export class UpdateUserPreferencesDto {
  @ApiProperty({
    description: 'Theme preference',
    example: 'system',
    enum: ['light', 'dark', 'system'],
    required: false,
  })
  @IsOptional()
  @IsString()
  theme?: string;

  @ApiProperty({
    description: 'Accent color',
    example: '#007bff',
    required: false,
  })
  @IsOptional()
  @IsString()
  accentColor?: string;

  @ApiProperty({
    description: 'Language ID',
    example: '123e4567-e89b-12d3-a456-426614174000',
    required: false,
  })
  @IsOptional()
  @IsUUID()
  languageId?: string;

  @ApiProperty({
    description: 'Default visibility for reviews',
    enum: Visibility,
    default: Visibility.Household,
    required: false,
  })
  @IsOptional()
  @IsEnum(Visibility)
  defaultReviewVisibility?: Visibility;

  @ApiProperty({
    description: 'Show online status',
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  showOnlineStatus?: boolean;

  @ApiProperty({
    description: 'Show last active time',
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  showLastActive?: boolean;

  @ApiProperty({
    description: 'Allow friend requests',
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  allowFriendRequests?: boolean;

  @ApiProperty({
    description: 'Show collection to friends',
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  showCollectionToFriends?: boolean;

  @ApiProperty({
    description: 'Show game play history',
    default: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  showGamePlayHistory?: boolean;

  @ApiProperty({
    description: 'Email notification preferences as JSON object',
    example: { gamePlays: true, friendRequests: true },
    required: false,
  })
  @IsOptional()
  emailNotifications?: object;

  @ApiProperty({
    description: 'Push notification preferences as JSON object',
    example: { gamePlays: true, friendRequests: true },
    required: false,
  })
  @IsOptional()
  pushNotifications?: object;

  @ApiProperty({
    description: 'Preferred player count',
    example: 4,
    required: false,
  })
  @IsOptional()
  preferredPlayerCount?: number;

  @ApiProperty({
    description: 'Preferred game length in minutes',
    example: 60,
    required: false,
  })
  @IsOptional()
  preferredGameLength?: number;

  @ApiProperty({
    description: 'Favorite categories',
    example: ['Strategy', 'Cooperative'],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  favoriteCategories?: string[];

  @ApiProperty({
    description: 'Favorite mechanics',
    example: ['Worker Placement', 'Deck Building'],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  favoriteMechanics?: string[];

  @ApiProperty({
    description: 'Disliked categories',
    example: ['Horror', 'War'],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  dislikedCategories?: string[];

  @ApiProperty({
    description: 'Disliked mechanics',
    example: ['Roll and Move', 'Player Elimination'],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  dislikedMechanics?: string[];
}
