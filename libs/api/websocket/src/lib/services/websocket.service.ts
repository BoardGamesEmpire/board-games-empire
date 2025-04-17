import { Injectable, Logger } from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import * as crypto from 'node:crypto';
import { Server, Socket } from 'socket.io';

// TODO: temporary. replace with actual types
type Handler = (...args: any[]) => any;

@Injectable()
export class WebSocketService {
  private readonly logger = new Logger(WebSocketService.name);
  private server!: Server;
  private connectedClients: Map<string, Socket> = new Map();
  private clientRooms: Map<string, Set<string>> = new Map();
  private requestHandlers: Map<string, Handler> = new Map();

  setServer(server: Server) {
    this.server = server;
  }

  registerClient(client: Socket) {
    this.connectedClients.set(client.id, client);
    this.clientRooms.set(client.id, new Set());
    return this.getConnectedCount();
  }

  removeClient(client: Socket) {
    this.connectedClients.delete(client.id);
    this.clientRooms.delete(client.id);
    return this.getConnectedCount();
  }

  getConnectedCount(): number {
    return this.connectedClients.size;
  }

  async joinRoom(client: Socket, roomId: string) {
    // Implement authorization check here if needed
    client.join(roomId);

    const room = this.clientRooms.get(client.id);
    if (room) {
      room.add(roomId);
    }

    const roomSize = this.server.sockets.adapter.rooms.get(roomId)?.size || 0;
    this.logger.log(`Client ${client.id} joined room ${roomId}. Room size: ${roomSize}`);

    return roomSize;
  }

  async leaveRoom(client: Socket, roomId: string) {
    client.leave(roomId);

    const room = this.clientRooms.get(client.id);
    if (room) {
      room.delete(roomId);
    }

    const roomSize = this.server.sockets.adapter.rooms.get(roomId)?.size || 0;
    this.logger.log(`Client ${client.id} left room ${roomId}. Room size: ${roomSize}`);

    return roomSize;
  }

  async createMessage(userId: string, content: string, roomId?: string) {
    try {
      const message = {
        id: crypto.randomBytes(32).toString('hex'),
        senderId: userId,
        content,
        roomId: roomId || 'general',
        timestamp: new Date(),
      };

      // database things. Need a model first..

      return message;
    } catch (error) {
      this.logger.error(`Error creating message: ${error.message}`);
      throw new WsException('Failed to create message');
    }
  }

  registerRequestHandler(type: string, handler: Handler) {
    this.requestHandlers.set(type, handler);
  }

  async handleRequest(client: Socket, type: string, payload: any): Promise<any> {
    const handler = this.requestHandlers.get(type);

    if (!handler) {
      throw new WsException(`No handler registered for request type: ${type}`);
    }

    try {
      return await handler(client.data.user, payload);
    } catch (error) {
      this.logger.error(`Error in request handler for ${type}: ${error.message}`);
      throw new WsException(error.message);
    }
  }

  sendToUser(userId: string, event: string, data: any) {
    this.server.to(`user:${userId}`).emit(event, data);
  }

  sendToRoom(roomId: string, event: string, data: any) {
    this.server.to(roomId).emit(event, data);
  }

  broadcast(event: string, data: any) {
    this.server.emit(event, data);
  }
}
