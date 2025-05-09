import { registerAs } from '@nestjs/config';
import Joi from 'joi';
import { env } from './env';

export interface RabbitMQConfig {
  uri: string;
  queue: string;
  exchange: string;
  routingKey: string;
  prefetchCount: number;
  queueOptions: {
    durable: boolean;
    autoDelete: boolean;
    exclusive: boolean;
    deadLetterExchange: string;
    deadLetterRoutingKey: string;
  };
}

export default registerAs('rabbitmq', () =>
  env.provideMany(
    [
      {
        keyTo: 'uri',
        key: 'RABBITMQ_URL',
        defaultsFor: {
          development: 'amqp://localhost:5672',
        },
      },
      {
        keyTo: 'queue',
        key: 'RABBITMQ_EXTERNAL_QUEUE',
        defaultValue: 'bge-external-game-sources',
      },
      {
        keyTo: 'exchange',
        key: 'RABBITMQ_EXCHANGE',
        defaultValue: 'board-games-empire',
      },
      {
        keyTo: 'routingKey',
        key: 'RABBITMQ_ROUTING_KEY',
        defaultValue: '#',
      },
      {
        keyTo: 'prefetchCount',
        key: 'RABBITMQ_PREFETCH_COUNT',
        defaultValue: 10,
        mutators: parseInt,
      },
    ],
    (record) =>
      <RabbitMQConfig>{
        uri: record.uri,
        queue: record.queue,
        exchange: record.exchange,
        routingKey: record.routingKey,
        prefetchCount: record.prefetchCount,
        queueOptions: {
          durable: true,
          autoDelete: false,
          exclusive: false,
          deadLetterExchange: `${record.queue}.dlx`,
          deadLetterRoutingKey: `${record.queue}.dlx`,
        },
      },
  ),
);

export const rabbitmqConfigValidationSchema = {
  RABBITMQ_URL: Joi.string().required().default('amqp://localhost:5672'),
  RABBITMQ_EXTERNAL_QUEUE: Joi.string().default('bge-external-game-sources'),
  RABBITMQ_EXCHANGE: Joi.string().default('board-games-empire'),
  RABBITMQ_ROUTING_KEY: Joi.string().default('#'),
  RABBITMQ_PREFETCH_COUNT: Joi.number().default(10),
};
