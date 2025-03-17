import { IsString, IsNotEmpty } from 'class-validator';

export class CreatePublisherDto {
  @IsNotEmpty()
  @IsString()
  name: string;
}
