import { RabbitMQModule } from '@golevelup/nestjs-rabbitmq';
import { Global, Logger, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { RabbitMQHealthCheckService } from './health-check.service';

const logger = new Logger('RabbitMQ');

@Global()
@Module({
  imports: [
    RabbitMQModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        exchanges: [
          {
            name: 'board-games-empire',
            type: 'topic',
            options: {
              durable: true,
            },
          },
        ],
        uri: configService.get('rabbitmq.uri'),
        queues: [
          {
            name: 'bge-external-game-sources',
            options: {
              durable: true,
            },
          },
        ],
        connectionInitOptions: {
          wait: false,
          reject: true,
          timeout: 9000,
        },
        logger,
        channels: {
          'channel-1': {
            prefetchCount: configService.get('rabbitmq.prefetchCount'),
            default: true,
          },
          'channel-2': {
            prefetchCount: 2,
          },
        },
      }),
    }),
  ],
  providers: [RabbitMQHealthCheckService],
  exports: [RabbitMQModule],
})
export class QueueModule {}
