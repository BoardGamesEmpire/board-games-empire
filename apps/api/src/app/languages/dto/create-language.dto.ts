import { IsNotEmpty, IsString, Length } from 'class-validator';

export class CreateLanguageDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @Length(3, 3)
  @IsNotEmpty()
  @IsString()
  code: string;

  @Length(2, 2)
  @IsNotEmpty()
  @IsString()
  abbreviation: string;
}
