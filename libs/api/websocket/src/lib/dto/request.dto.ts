import { IsNotEmpty, IsObject, IsString } from 'class-validator';

export class WebSocketRequestDto {
  @IsNotEmpty()
  @IsString()
  type: string;

  @IsNotEmpty()
  @IsString()
  requestId: string;

  @IsNotEmpty()
  @IsObject()
  payload: Record<string, any>;
}
