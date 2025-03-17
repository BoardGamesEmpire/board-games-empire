import { IsNotEmpty, IsString, IsUUID, IsOptional } from 'class-validator';

export class CreateHouseholdDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  image?: string;

  @IsUUID()
  languageId: string;

  @IsUUID()
  ownerId: string;
}
