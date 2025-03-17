import { IsString, IsNotEmpty, IsOptional, IsNumber, Min, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateGameDto {
  @ApiProperty()
  @IsUUID()
  typeId: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  subtitle: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  image?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  @Min(1)
  minPlayers?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  maxPlayers?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  minPlayTime?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  maxPlayTime?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumber()
  minAge?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  publisherId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  mechanicId?: string;
}
