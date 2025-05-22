import { INestApplicationContext, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { IoAdapter } from '@nestjs/platform-socket.io';
import { Server, ServerOptions, Socket } from 'socket.io';

export class WsAuthAdapter extends IoAdapter {
  private readonly logger = new Logger(WsAuthAdapter.name);

  private readonly jwtService: JwtService;

  constructor(private app: INestApplicationContext) {
    super(app);
    this.jwtService = this.app.get(JwtService);
  }

  override createIOServer(port: number, options?: ServerOptions): Server {
    const server = super.createIOServer(port, options);

    server.use(async (socket: Socket, next: (error?: Error) => void) => {
      try {
        const token =
          socket.handshake.auth.token ||
          socket.handshake.headers.authorization?.split(' ')[1] ||
          (socket.handshake.query.token as string);

        if (!token) {
          return next(new Error('Authentication error: No token provided'));
        }

        const payload = await this.jwtService.verifyAsync(token);
        (socket as any).user = payload;

        next();
      } catch (error) {
        this.logger.error('Authentication error', error);
        next(new Error('Authentication error: Invalid token'));
      }
    });

    return server;
  }
}
