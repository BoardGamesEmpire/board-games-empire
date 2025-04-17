import { IsNotEmpty, IsString } from 'class-validator';

export class LeaveRoomDto {
  @IsNotEmpty()
  @IsString()
  roomId: string;
}
