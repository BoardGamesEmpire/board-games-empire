import { IsNotEmpty, IsString } from 'class-validator';

export class CreateGameTypeDto {
  @IsNotEmpty()
  @IsString()
  name: string;
}
