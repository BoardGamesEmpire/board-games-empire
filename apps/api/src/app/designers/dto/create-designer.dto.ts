import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateDesignerDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  name: string;
}
