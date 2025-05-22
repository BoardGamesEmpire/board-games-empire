import { GameGatewayResponseDto } from '../game-gateway-response.dto';

export class GameGatewayWebSocketResponseDto {
  requestId: string;
  success: boolean;
  data?: GameGatewayResponseDto | GameGatewayResponseDto[] | { message: string };
  error?: string;
}
