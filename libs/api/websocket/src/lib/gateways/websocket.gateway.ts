import { Logger, UseGuards } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WsException,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { WsJwtGuard } from '../guards/ws-jwt.guard';
import { WebSocketAuthService } from '../services/websocket-auth.service';
import { WebSocketService } from '../services/websocket.service';

@WebSocketGateway({
  cors: {
    origin: '*',
    credentials: true,
  },
  namespace: 'socket',
})
export class WSGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  private readonly logger = new Logger(WSGateway.name);

  server: Server;

  constructor(private readonly wsService: WebSocketService, private readonly wsAuthService: WebSocketAuthService) {}

  afterInit(server: Server) {
    this.logger.log('WebSocket Server Initialized');
    this.wsService.setServer(server);
  }

  async handleConnection(client: Socket) {
    try {
      const user = await this.wsAuthService.validateToken(client);
      if (!user) {
        this.logger.warn(`Client ${client.id} disconnected - Invalid token`);
        client.disconnect(true);
        return;
      }

      client.data.user = user;
      this.wsService.registerClient(client);

      client.join(`user:${user.id}`);

      this.logger.log(`Client connected: ${client.id} - User: ${user.username} (${user.id})`);
    } catch (error) {
      this.logger.error(`Connection error: ${error.message}`);
      client.disconnect(true);
    }
  }

  handleDisconnect(client: Socket) {
    this.wsService.removeClient(client);
    this.logger.log(`Client disconnected: ${client.id}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('joinRoom')
  async handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() data: { roomId: string }) {
    try {
      if (!data?.roomId) {
        throw new WsException('Room ID is required');
      }

      await this.wsService.joinRoom(client, data.roomId);
      return { success: true, roomId: data.roomId };
    } catch (error) {
      this.logger.error(`Error joining room: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('leaveRoom')
  async handleLeaveRoom(@ConnectedSocket() client: Socket, @MessageBody() data: { roomId: string }) {
    try {
      if (!data?.roomId) {
        throw new WsException('Room ID is required');
      }

      client.leave(data.roomId);
      return { success: true, roomId: data.roomId };
    } catch (error) {
      this.logger.error(`Error leaving room: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('sendMessage')
  async handleMessage(@ConnectedSocket() client: Socket, @MessageBody() data: { content: string; roomId?: string }) {
    try {
      if (!data?.content) {
        throw new WsException('Message content is required');
      }

      const user = client.data.user;
      const message = await this.wsService.createMessage(user.id, data.content, data.roomId);

      const roomId = data.roomId || 'general';
      this.server.to(roomId).emit('chatMessage', {
        ...message,
        senderName: user.username,
      });

      return { success: true, messageId: message.id };
    } catch (error) {
      this.logger.error(`Error sending message: ${error.message}`);
      return { success: false, error: error.message };
    }
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('request')
  async handleRequest(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { type: string; requestId: string; payload: any },
  ) {
    try {
      if (!data?.type || !data.requestId) {
        throw new WsException('Invalid request format');
      }

      const response = await this.wsService.handleRequest(client, data.type, data.payload);

      return {
        requestId: data.requestId,
        payload: response,
      };
    } catch (error) {
      this.logger.error(`Error handling request ${data?.type}: ${error.message}`);
      return {
        requestId: data?.requestId,
        error: error.message,
      };
    }
  }
}
