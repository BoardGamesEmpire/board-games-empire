import { registerAs } from '@nestjs/config';
import Joi from 'joi';
import { env } from './env';

export interface DatabaseConfig {
  adaptor: string;
  port: number;
  host: string;
  database: string;
  schema: string;
  user: string;
  password: string;
}

export default registerAs('database', () =>
  env.provideMany<DatabaseConfig>([
    {
      keyTo: 'url',
      defaultValue: '',
      key: 'DATABASE_URL',
      allowEmptyString: true,
    },
    {
      keyTo: 'adaptor',
      key: 'DATABASE_ADAPTER',
      defaultValue: 'postgresql',
    },
    {
      keyTo: 'port',
      mutators: parseInt,
      defaultValue: 5432,
      key: 'DATABASE_PORT',
    },
    {
      keyTo: 'host',
      key: 'DATABASE_HOST',
      defaultValue: 'localhost',
    },
    {
      keyTo: 'database',
      key: 'DATABASE_NAME',
      defaultValue: 'board_games_empire',
    },
    {
      keyTo: 'schema',
      key: 'DATABASE_SCHEMA',
      defaultValue: 'public',
    },
    {
      keyTo: 'user',
      key: 'DATABASE_USER',
      defaultValue: 'postgres',
      productionDefaults: false,
    },
    {
      keyTo: 'password',
      key: 'DATABASE_PASSWORD',
      defaultValue: 'postgres',
      productionDefaults: false,
    },
  ]),
);

export const databaseConfigValidationSchema = {
  DATABASE_URL: Joi.string().required(),
  DATABASE_ADAPTER: Joi.string().default('postgresql'),
  DATABASE_PORT: Joi.number().default(5432),
  DATABASE_HOST: Joi.string().default('localhost'),
  DATABASE_NAME: Joi.string().default('board_games_empire'),
  DATABASE_SCHEMA: Joi.string().default('public'),
  DATABASE_USER: Joi.string().default('postgres'),
  DATABASE_PASSWORD: Joi.string().default('postgres'),
};
