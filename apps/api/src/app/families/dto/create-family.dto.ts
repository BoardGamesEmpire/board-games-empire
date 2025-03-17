import { IsNotEmpty, IsString } from 'class-validator';

export class CreateFamilyDto {
  @IsNotEmpty()
  @IsString()
  name: string;
}
