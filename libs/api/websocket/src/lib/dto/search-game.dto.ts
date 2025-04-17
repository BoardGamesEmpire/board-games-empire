import { IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

export class SearchGamesDto {
  @IsNotEmpty()
  @IsString()
  @MaxLength(100)
  query: string;

  @IsOptional()
  @IsString()
  externalSource?: string;
}
