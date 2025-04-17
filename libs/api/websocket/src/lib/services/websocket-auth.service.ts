import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { WsException } from '@nestjs/websockets';
import { Socket } from 'socket.io';

@Injectable()
export class WebSocketAuthService {
  private readonly logger = new Logger(WebSocketAuthService.name);

  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  async validateToken(client: Socket) {
    try {
      const token = this.extractToken(client);
      if (!token) {
        throw new UnauthorizedException('Authentication token is missing');
      }

      const payload = await this.jwtService.verifyAsync(token, {
        secret: this.configService.get<string>('jwt.secret'),
      });

      if (!payload) {
        throw new UnauthorizedException('Invalid authentication token');
      }

      const tokenRecord = await this.prisma.token.findFirst({
        where: {
          token,
          type: 'Access',
          isRevoked: false,
          expiresAt: { gt: new Date() },
        },
      });

      if (!tokenRecord) {
        throw new UnauthorizedException('Token has been revoked or expired');
      }

      if (payload.sid) {
        const session = await this.prisma.userSession.findFirst({
          where: {
            id: payload.sid,
            isValid: true,
            expiresAt: { gt: new Date() },
          },
        });

        if (!session) {
          throw new UnauthorizedException('Session is invalid or expired');
        }
      }

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
        select: {
          id: true,
          username: true,
          firstName: true,
          lastName: true,
          profileImage: true,

          authentication: {
            select: {
              email: true,
              emailVerified: true,
              authStrategy: true,
            },
          },
        },
      });

      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      return {
        id: user.id,
        username: user.username,
        email: user.authentication!.email,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.profileImage,
      };
    } catch (error) {
      this.logger.error(`Authentication error: ${error.message}`);
      throw new WsException('Authentication failed');
    }
  }

  private extractToken(client: Socket): string | null {
    const authorization = client.handshake.headers.authorization;
    if (typeof authorization === 'string') {
      const parts = authorization.split(' ');
      if (parts.length === 2 && parts[0] === 'Bearer') {
        return parts[1];
      }
    }

    const { token } = client.handshake.auth;
    if (token) {
      return token;
    }

    const queryToken = client.handshake.query.authentication;
    if (queryToken && typeof queryToken === 'string') {
      return queryToken;
    }

    return null;
  }
}
