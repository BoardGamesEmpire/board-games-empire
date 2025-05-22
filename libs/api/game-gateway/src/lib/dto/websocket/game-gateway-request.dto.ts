import { Type } from 'class-transformer';
import { IsEnum, IsNotEmpty, IsOptional, IsString, IsUUID, ValidateNested } from 'class-validator';
import { CreateGameGatewayDto } from '../create-game-gateway.dto';
import { UpdateGameGatewayDto } from '../update-game-gateway.dto';

export enum GameGatewayAction {
  Create = 'gameGateway/create',
  FindAll = 'gameGateway/findAll',
  FindOne = 'gameGateway/findOne',
  Update = 'gameGateway/update',
  Delete = 'gameGateway/delete',
  RecordUsage = 'gameGateway/recordUsage',
}

export class GameGatewayRequestDto {
  @IsNotEmpty()
  @IsString()
  requestId: string;

  @IsNotEmpty()
  @IsEnum(GameGatewayAction)
  action: GameGatewayAction;

  @IsOptional()
  @IsUUID()
  id?: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => CreateGameGatewayDto)
  createDto?: CreateGameGatewayDto;

  @IsOptional()
  @ValidateNested()
  @Type(() => UpdateGameGatewayDto)
  updateDto?: UpdateGameGatewayDto;

  @IsOptional()
  filters?: {
    enabled?: boolean;
  };
}
