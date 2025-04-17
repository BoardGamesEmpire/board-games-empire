import { CanActivate, ExecutionContext, Injectable, Logger } from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import { Socket } from 'socket.io';
import { WebSocketAuthService } from '../services/websocket-auth.service';

@Injectable()
export class WsJwtGuard implements CanActivate {
  private readonly logger = new Logger(WsJwtGuard.name);

  constructor(private readonly wsAuthService: WebSocketAuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    this.logger.log('Checking WebSocket JWT Guard');
    try {
      const client = context.switchToWs().getClient<Socket>();

      if (client.data?.user) {
        return true;
      }

      const user = await this.wsAuthService.validateToken(client);

      client.data.user = user;

      return Boolean(user);
    } catch (error) {
      this.logger.error(`WsJwtGuard error: ${error.message}`);
      throw new WsException('Unauthorized');
    }
  }
}
