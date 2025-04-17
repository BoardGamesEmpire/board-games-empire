import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, Logger, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import { ChatRoomType } from '@prisma/client';
import { WebSocketService } from './websocket.service';

@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  constructor(private readonly prisma: PrismaService, private readonly wsService: WebSocketService) {}

  async getRooms(userId: string) {
    try {
      const rooms = await this.prisma.chatRoomMember.findMany({
        where: {
          userId,
        },
        select: {
          room: {
            select: {
              id: true,
              name: true,
              description: true,
              type: true,
              householdId: true,
              gameId: true,
              eventId: true,
              createdAt: true,
              updatedAt: true,
              _count: {
                select: {
                  members: true,
                  messages: true,
                },
              },
            },
          },
          role: true,
          joinedAt: true,
          lastRead: true,
          isMuted: true,
        },
        orderBy: {
          joinedAt: 'desc',
        },
      });

      const roomIds = rooms.map((r) => r.room.id);
      const latestMessages = await this.prisma.chatMessage.findMany({
        where: {
          roomId: {
            in: roomIds,
          },
        },
        orderBy: {
          createdAt: 'desc',
        },
        distinct: ['roomId'],
        select: {
          id: true,
          roomId: true,
          content: true,
          createdAt: true,
          sender: {
            select: {
              id: true,
              username: true,
            },
          },
        },
      });

      return rooms.map((room) => {
        const latestMessage = latestMessages.find((m) => m.roomId === room.room.id);
        return {
          id: room.room.id,
          name: room.room.name,
          description: room.room.description,
          type: room.room.type,
          memberCount: room.room._count.members,
          messageCount: room.room._count.messages,
          userRole: room.role,
          joinedAt: room.joinedAt,
          lastRead: room.lastRead,
          isMuted: room.isMuted,
          latestMessage: latestMessage
            ? {
                id: latestMessage.id,
                content: latestMessage.content,
                createdAt: latestMessage.createdAt,
                sender: latestMessage.sender.username,
              }
            : null,
          metadata: {
            householdId: room.room.householdId,
            gameIds: room.room.gameId,
            eventId: room.room.eventId,
          },
        };
      });
    } catch (error) {
      this.logger.error(`Error fetching user rooms: ${error.message}`);
      throw new WsException('Failed to fetch chat rooms');
    }
  }

  async getMessages(userId: string, roomId: string, limit = 50, before?: Date) {
    try {
      const membership = await this.prisma.chatRoomMember.findUnique({
        where: {
          roomId_userId: {
            roomId,
            userId,
          },
        },
      });

      if (!membership) {
        const room = await this.prisma.chatRoom.findUnique({
          where: { id: roomId },
          select: { type: true },
        });

        if (room?.type !== ChatRoomType.Public) {
          throw new UnauthorizedException('You are not a member of this room');
        }
      }

      if (membership) {
        await this.prisma.chatRoomMember.update({
          where: {
            id: membership.id,
          },
          data: {
            lastRead: new Date(),
          },
        });
      }

      const messages = await this.prisma.chatMessage.findMany({
        where: {
          roomId,
          ...(before ? { createdAt: { lt: before } } : {}),
        },
        orderBy: {
          createdAt: 'desc',
        },
        take: limit,
        select: {
          id: true,
          content: true,
          isSystem: true,
          isEdited: true,
          editedAt: true,
          createdAt: true,
          replyToId: true,
          metadata: true,
          sender: {
            select: {
              id: true,
              username: true,
              profileImage: true,
            },
          },
          replyTo: {
            select: {
              id: true,
              content: true,
              sender: {
                select: {
                  id: true,
                  username: true,
                },
              },
            },
          },
          _count: {
            select: {
              reactions: true,
            },
          },
        },
      });

      type Reaction = {
        messageId: string;
        emoji: string;
        user: {
          id: string;
          username: string;
        };
      };

      const messageIds = messages.map((m) => m.id);
      const reactions: Reaction[] = await this.prisma.chatMessageReaction.findMany({
        where: {
          messageId: {
            in: messageIds,
          },
        },
        select: {
          messageId: true,
          emoji: true,
          user: {
            select: {
              id: true,
              username: true,
            },
          },
        },
      });

      const reactionsMap = new Map();
      for (const reaction of reactions) {
        if (!reactionsMap.has(reaction.messageId)) {
          reactionsMap.set(reaction.messageId, []);
        }

        reactionsMap.get(reaction.messageId).push({
          emoji: reaction.emoji,
          userId: reaction.user.id,
          username: reaction.user.username,
        });
      }

      return messages.map((message) => ({
        id: message.id,
        content: message.content,
        isSystem: message.isSystem,
        isEdited: message.isEdited,
        editedAt: message.editedAt,
        createdAt: message.createdAt,
        sender: {
          id: message.sender.id,
          username: message.sender.username,
          profileImage: message.sender.profileImage,
        },
        replyTo: message.replyTo
          ? {
              id: message.replyTo.id,
              content: message.replyTo.content,
              sender: message.replyTo.sender.username,
            }
          : null,
        reactions: reactionsMap.get(message.id) || [],
        reactionCount: message._count.reactions,
        metadata: message.metadata,
      }));
    } catch (error) {
      this.logger.error(`Error fetching messages: ${error.message}`);
      if (error instanceof UnauthorizedException) {
        throw new WsException(error.message);
      }

      throw new WsException('Failed to fetch messages');
    }
  }

  async sendMessage(userId: string, roomId: string, content: string, replyToId?: string, metadata?: any) {
    try {
      const membership = await this.prisma.chatRoomMember.findUnique({
        where: {
          roomId_userId: {
            roomId,
            userId,
          },
        },
      });

      if (!membership) {
        const room = await this.prisma.chatRoom.findUnique({
          where: { id: roomId },
          select: { type: true },
        });

        if (!room) {
          throw new NotFoundException('Chat room not found');
        }

        if (room.type !== ChatRoomType.Public) {
          throw new UnauthorizedException('You are not a member of this room');
        }

        await this.prisma.chatRoomMember.create({
          data: {
            roomId,
            userId,
            role: 'Member',
          },
        });
      }

      if (replyToId) {
        const replyMessage = await this.prisma.chatMessage.findUnique({
          where: { id: replyToId },
          select: { id: true },
        });

        if (!replyMessage) {
          replyToId = undefined;
        }
      }

      const message = await this.prisma.chatMessage.create({
        data: {
          roomId,
          senderId: userId,
          content,
          replyToId,
          metadata,
        },
        include: {
          sender: {
            select: {
              id: true,
              username: true,
              profileImage: true,
            },
          },
          replyTo: {
            select: {
              id: true,
              content: true,
              sender: {
                select: {
                  id: true,
                  username: true,
                },
              },
            },
          },
        },
      });

      const formattedMessage = {
        id: message.id,
        roomId,
        content: message.content,
        createdAt: message.createdAt,
        sender: {
          id: message.sender.id,
          username: message.sender.username,
          profileImage: message.sender.profileImage,
        },
        replyTo: message.replyTo
          ? {
              id: message.replyTo.id,
              content: message.replyTo.content,
              sender: message.replyTo.sender.username,
            }
          : null,
        metadata: message.metadata,
      };

      this.wsService.sendToRoom(roomId, 'chatMessage', formattedMessage);

      return formattedMessage;
    } catch (error) {
      this.logger.error(`Error sending message: ${error.message}`);
      if (error instanceof UnauthorizedException || error instanceof NotFoundException) {
        throw new WsException(error.message);
      }

      throw new WsException('Failed to send message');
    }
  }

  async joinRoom(userId: string, roomId: string) {
    try {
      const room = await this.prisma.chatRoom.findUnique({
        where: { id: roomId },
        select: { id: true, type: true },
      });

      if (!room) {
        throw new NotFoundException('Chat room not found');
      }

      const existingMembership = await this.prisma.chatRoomMember.findUnique({
        where: {
          roomId_userId: {
            roomId,
            userId,
          },
        },
      });

      if (existingMembership) {
        return { alreadyMember: true, roomId };
      }

      // TODO: room invites
      if (room.type !== ChatRoomType.Public) {
        // TODO: check for invites or permissions - if event room, check for event invite
        throw new UnauthorizedException('This room requires an invitation to join');
      }

      await this.prisma.chatRoomMember.create({
        data: {
          roomId,
          userId,
          role: 'Member',
        },
      });

      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { username: true },
      });

      this.wsService.sendToRoom(roomId, 'userJoined', {
        userId,
        username: user?.username,
        roomId,
        timestamp: new Date(),
      });

      return { success: true, roomId };
    } catch (error) {
      this.logger.error(`Error joining room: ${error.message}`);
      if (error instanceof UnauthorizedException || error instanceof NotFoundException) {
        throw new WsException(error.message);
      }

      throw new WsException('Failed to join room');
    }
  }

  async leaveRoom(userId: string, roomId: string) {
    try {
      const room = await this.prisma.chatRoom.findUnique({
        where: { id: roomId },
        select: { id: true },
      });

      if (!room) {
        throw new NotFoundException('Chat room not found');
      }

      const membership = await this.prisma.chatRoomMember.findUnique({
        where: {
          roomId_userId: {
            roomId,
            userId,
          },
        },
      });

      if (!membership) {
        throw new UnauthorizedException('You are not a member of this room');
      }

      await this.prisma.chatRoomMember.delete({
        where: {
          id: membership.id,
        },
      });

      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { username: true },
      });

      this.wsService.sendToRoom(roomId, 'userLeft', {
        userId,
        username: user?.username,
        roomId,
        timestamp: new Date(),
      });

      return { success: true, roomId };
    } catch (error) {
      this.logger.error(`Error leaving room: ${error.message}`);
      if (error instanceof UnauthorizedException || error instanceof NotFoundException) {
        throw new WsException(error.message);
      }

      throw new WsException('Failed to leave room');
    }
  }

  async addReaction(userId: string, messageId: string, emoji: string) {
    try {
      const message = await this.prisma.chatMessage.findUnique({
        where: { id: messageId },
        select: { id: true, roomId: true },
      });

      if (!message) {
        throw new NotFoundException('Message not found');
      }

      const membership = await this.prisma.chatRoomMember.findUnique({
        where: {
          roomId_userId: {
            roomId: message.roomId,
            userId,
          },
        },
      });

      if (!membership) {
        throw new UnauthorizedException('You are not a member of this room');
      }

      await this.prisma.chatMessageReaction.upsert({
        where: {
          messageId_userId_emoji: {
            messageId,
            userId,
            emoji,
          },
        },
        update: {},
        create: {
          messageId,
          userId,
          emoji,
        },
      });

      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { username: true },
      });

      this.wsService.sendToRoom(message.roomId, 'messageReaction', {
        messageId,
        userId,
        username: user?.username,
        emoji,
        timestamp: new Date(),
      });

      return { success: true, messageId, emoji };
    } catch (error) {
      this.logger.error(`Error adding reaction: ${error.message}`);
      if (error instanceof UnauthorizedException || error instanceof NotFoundException) {
        throw new WsException(error.message);
      }
      throw new WsException('Failed to add reaction');
    }
  }

  async removeReaction(userId: string, messageId: string, emoji: string) {
    try {
      const message = await this.prisma.chatMessage.findUnique({
        where: { id: messageId },
        select: { id: true, roomId: true },
      });

      if (!message) {
        throw new NotFoundException('Message not found');
      }

      await this.prisma.chatMessageReaction.delete({
        where: {
          messageId_userId_emoji: {
            messageId,
            userId,
            emoji,
          },
        },
      });

      this.wsService.sendToRoom(message.roomId, 'messageReactionRemoved', {
        messageId,
        userId,
        emoji,
        timestamp: new Date(),
      });

      return { success: true, messageId, emoji };
    } catch (error) {
      this.logger.error(`Error removing reaction: ${error.message}`);
      if (error instanceof NotFoundException) {
        throw new WsException(error.message);
      }

      if (error.code === 'P2025') {
        return { success: true, messageId, emoji };
      }
      throw new WsException('Failed to remove reaction');
    }
  }

  async createRoom(
    userId: string,
    name: string,
    description?: string,
    type: ChatRoomType = ChatRoomType.Public,
    metadata?: any,
  ) {
    try {
      const room = await this.prisma.chatRoom.create({
        data: {
          name,
          description,
          type,

          ...(metadata?.householdId ? { householdId: metadata.householdId } : {}),
          ...(metadata?.gameId ? { gameId: metadata.gameId } : {}),
          ...(metadata?.eventId ? { eventId: metadata.eventId } : {}),

          members: {
            create: {
              userId,
              role: 'Owner',
            },
          },
        },
      });

      await this.prisma.chatMessage.create({
        data: {
          roomId: room.id,
          senderId: userId,
          content: 'Welcome to the room!',
          isSystem: true,
        },
      });

      return {
        id: room.id,
        name: room.name,
        description: room.description,
        type: room.type,
        createdAt: room.createdAt,
      };
    } catch (error) {
      this.logger.error(`Error creating room: ${error.message}`);
      throw new WsException('Failed to create room');
    }
  }
}
