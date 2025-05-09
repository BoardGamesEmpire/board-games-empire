import { registerAs } from '@nestjs/config';
import Joi from 'joi';
import { env } from './env';

export default registerAs('server', () => ({
  port: env.provide<number>('SERVER_PORT', {
    defaultValue: 33333,
    mutators: [(value: string) => parseInt(value, 10)],
  }),
  api_base_url: env.provide<string>('API_BASE_URL', {
    defaultValue: 'http://localhost',
  }),
}));

export const serverConfigValidationSchema = {
  SERVER_PORT: Joi.number().default(33333),
  API_BASE_URL: Joi.string().default('http://localhost'),
};
