import { AuthModule, JwtAuthGuard } from '@bg-empire/api-auth';
import { PrismaModule } from '@bg-empire/api-prisma';
import { UsersModule } from '@bg-empire/api-users';
import { WebSocketModule } from '@bg-empire/api-websocket';
import { NestConfigModule } from '@bge/config';
import { QueueModule } from '@bge/microservices-queue';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [
    NestConfigModule,

    // Rate limiting
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        throttlers: [
          {
            name: 'default',
            ttl: config.get<number>('throttle.ttl'),
            limit: config.get<number>('throttle.limit'),
          },
        ],
      }),
    }),

    // Database
    PrismaModule,

    // TODO: Move to a separate module
    PrometheusModule.register({
      defaultLabels: { app: 'BoardGamesEmpire' },
      defaultMetrics: { enabled: true },
    }),

    // Feature modules
    AuthModule,
    UsersModule,
    WebSocketModule,
    QueueModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,

    // Global guards
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
  ],
})
export class AppModule {}
