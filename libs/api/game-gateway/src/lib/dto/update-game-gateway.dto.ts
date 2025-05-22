import { PartialType } from '@nestjs/swagger';
import { CreateGameGatewayDto } from './create-game-gateway.dto';

export class UpdateGameGatewayDto extends PartialType(CreateGameGatewayDto) {}
