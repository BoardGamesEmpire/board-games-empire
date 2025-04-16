import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString } from 'class-validator';

export class LogoutDto {
  @ApiProperty({
    description: 'Session ID to be logged out',
    example: '1234567890abcdef',
  })
  @IsOptional()
  @IsString()
  sessionId?: string;

  @ApiProperty({
    description: 'Should all sessions be logged out',
    example: true,
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  allSessions = false;
}
