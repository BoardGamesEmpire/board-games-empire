import { PrismaModule } from '@bg-empire/api-prisma';
import { INestApplication, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';

import { WebSocketAdapter } from './adapters/websocket.adapter';
import { WSGateway } from './gateways/websocket.gateway';
import { ChatMessageHandler } from './handlers/chat-message.handler';
import { GameSearchHandler } from './handlers/game-search.handler';
import { ChatService } from './services/chat.service';
import { WebSocketAuthService } from './services/websocket-auth.service';
import { WebSocketService } from './services/websocket.service';

@Module({
  imports: [
    PrismaModule,
    ConfigModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        secret: configService.get('jwt.secret'),
        signOptions: {
          expiresIn: configService.get('jwt.expiresIn', '1h'),
        },
      }),
    }),
  ],
  providers: [WSGateway, WebSocketService, WebSocketAuthService, GameSearchHandler, ChatMessageHandler, ChatService],
  exports: [WebSocketService, WebSocketAuthService, ChatService],
})
export class WebSocketModule {
  static getAdapter(app: INestApplication) {
    return new WebSocketAdapter(app);
  }
}
