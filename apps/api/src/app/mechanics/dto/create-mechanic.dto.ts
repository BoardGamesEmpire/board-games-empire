import { IsNotEmpty, IsString } from 'class-validator';

export class CreateMechanicDto {
  @IsNotEmpty()
  @IsString()
  name: string;
}
