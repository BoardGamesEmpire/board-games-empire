import { IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

export class ChatMessageDto {
  @IsNotEmpty()
  @IsString()
  @MaxLength(5000)
  content: string;

  @IsOptional()
  @IsString()
  roomId?: string;
}
