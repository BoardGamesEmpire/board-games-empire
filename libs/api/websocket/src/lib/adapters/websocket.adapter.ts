import { INestApplicationContext, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IoAdapter } from '@nestjs/platform-socket.io';
import { ServerOptions, Socket } from 'socket.io';

export class WebSocketAdapter extends IoAdapter {
  private readonly logger = new Logger(WebSocketAdapter.name);
  private readonly configService: ConfigService;

  constructor(app: INestApplicationContext) {
    super(app);
    this.configService = app.get(ConfigService);
  }

  override createIOServer(port: number, options?: ServerOptions) {
    const corsOrigin = this.configService.get<string | string[]>('security.cors.origin');

    const serverOptions: ServerOptions = {
      ...options,
      cors: {
        origin: corsOrigin || '*',
        credentials: this.configService.get<boolean>('security.cors.credentials', true),
        methods: ['GET', 'POST'],
      },
      allowEIO3: true,
      maxHttpBufferSize: 1e8,
      pingTimeout: 60000,
      pingInterval: 25000,
      transports: ['websocket', 'polling'],
    };

    this.logger.log(`Creating Socket.IO server with CORS origin: ${corsOrigin}`);

    const server = super.createIOServer(port, serverOptions);

    server.use((socket: Socket, next: (error?: Error) => void) => {
      const clientIp = socket.handshake.address;
      this.logger.debug(`Client connecting from IP: ${clientIp}`);
      next();
    });

    return server;
  }
}
