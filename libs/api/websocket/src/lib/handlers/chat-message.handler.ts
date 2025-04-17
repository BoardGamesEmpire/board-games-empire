import { Injectable, Logger } from '@nestjs/common';
import { ChatService } from '../services/chat.service';
import { WebSocketService } from '../services/websocket.service';

@Injectable()
export class ChatMessageHandler {
  private readonly logger = new Logger(ChatMessageHandler.name);

  constructor(private readonly wsService: WebSocketService, private readonly chatService: ChatService) {
    this.wsService.registerRequestHandler('getChatHistory', this.handleGetChatHistory.bind(this));
    this.wsService.registerRequestHandler('getChatRooms', this.handleGetChatRooms.bind(this));
    this.wsService.registerRequestHandler('joinChatRoom', this.handleJoinRoom.bind(this));
    this.wsService.registerRequestHandler('leaveChatRoom', this.handleLeaveRoom.bind(this));
    this.wsService.registerRequestHandler('sendChatMessage', this.handleSendMessage.bind(this));
    this.wsService.registerRequestHandler('addMessageReaction', this.handleAddReaction.bind(this));
    this.wsService.registerRequestHandler('removeMessageReaction', this.handleRemoveReaction.bind(this));
    this.wsService.registerRequestHandler('createChatRoom', this.handleCreateRoom.bind(this));
  }

  async handleGetChatHistory(user: any, payload: { roomId: string; limit?: number; before?: string }) {
    try {
      const { roomId, limit = 50, before } = payload;

      if (!roomId) {
        throw new Error('Room ID is required');
      }

      const beforeDate = before ? new Date(before) : undefined;
      return await this.chatService.getMessages(user.id, roomId, limit, beforeDate);
    } catch (error) {
      this.logger.error(`Error getting chat history: ${error.message}`);
      throw error;
    }
  }

  async handleGetChatRooms(user: any) {
    try {
      return await this.chatService.getRooms(user.id);
    } catch (error) {
      this.logger.error(`Error getting chat rooms: ${error.message}`);
      throw error;
    }
  }

  async handleJoinRoom(user: any, payload: { roomId: string }) {
    try {
      const { roomId } = payload;

      if (!roomId) {
        throw new Error('Room ID is required');
      }

      return await this.chatService.joinRoom(user.id, roomId);
    } catch (error) {
      this.logger.error(`Error joining room: ${error.message}`);
      throw error;
    }
  }

  async handleLeaveRoom(user: any, payload: { roomId: string }) {
    try {
      const { roomId } = payload;

      if (!roomId) {
        throw new Error('Room ID is required');
      }

      return await this.chatService.leaveRoom(user.id, roomId);
    } catch (error) {
      this.logger.error(`Error leaving room: ${error.message}`);
      throw error;
    }
  }

  async handleSendMessage(user: any, payload: { roomId: string; content: string; replyToId?: string; metadata?: any }) {
    try {
      const { roomId, content, replyToId, metadata } = payload;

      if (!roomId) {
        throw new Error('Room ID is required');
      }

      if (!content) {
        throw new Error('Message content is required');
      }

      return await this.chatService.sendMessage(user.id, roomId, content, replyToId, metadata);
    } catch (error) {
      this.logger.error(`Error sending message: ${error.message}`);
      throw error;
    }
  }

  async handleAddReaction(user: any, payload: { messageId: string; emoji: string }) {
    try {
      const { messageId, emoji } = payload;

      if (!messageId) {
        throw new Error('Message ID is required');
      }

      if (!emoji) {
        throw new Error('Emoji is required');
      }

      return await this.chatService.addReaction(user.id, messageId, emoji);
    } catch (error) {
      this.logger.error(`Error adding reaction: ${error.message}`);
      throw error;
    }
  }

  async handleRemoveReaction(user: any, payload: { messageId: string; emoji: string }) {
    try {
      const { messageId, emoji } = payload;

      if (!messageId) {
        throw new Error('Message ID is required');
      }

      if (!emoji) {
        throw new Error('Emoji is required');
      }

      return await this.chatService.removeReaction(user.id, messageId, emoji);
    } catch (error) {
      this.logger.error(`Error removing reaction: ${error.message}`);
      throw error;
    }
  }

  async handleCreateRoom(user: any, payload: { name: string; description?: string; type?: string; metadata?: any }) {
    try {
      const { name, description, type, metadata } = payload;

      if (!name) {
        throw new Error('Room name is required');
      }

      return await this.chatService.createRoom(user.id, name, description, (type as any) || 'Public', metadata);
    } catch (error) {
      this.logger.error(`Error creating room: ${error.message}`);
      throw error;
    }
  }
}
