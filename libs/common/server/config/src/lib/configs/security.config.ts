import { registerAs } from '@nestjs/config';
import Joi from 'joi';
import { env } from './env';
import { isTrue } from './helpers/helpers';

export interface SecurityConfig {
  saltRounds: number;
  cors: {
    origin: string;
    credentials: boolean;
  };
}

export default registerAs('security', () =>
  env.provideMany(
    [
      {
        keyTo: 'saltRounds',
        key: 'BCRYPT_SALT_ROUNDS',
        defaultValue: 12,
        mutators: [(value: string) => parseInt(value, 10)],
      },
      {
        keyTo: 'corsCredentials',
        key: 'CORS_CREDENTIALS',
        defaultValue: false,
        mutators: [isTrue],
      },
      {
        keyTo: 'corsOrigin',
        key: 'CORS_ORIGIN',
        defaultValue: '*',
      },
    ],
    (record: Record<string, any>) =>
      <SecurityConfig>{
        saltRounds: record.saltRounds,
        cors: {
          origin: record.corsOrigin,
          credentials: record.corsCredentials,
        },
      },
  ),
);

export const securityConfigValidationSchema = {
  BCRYPT_SALT_ROUNDS: Joi.number().default(12),
  CORS_CREDENTIALS: Joi.boolean().default(false),
  CORS_ORIGIN: Joi.string().default('*'),
};
