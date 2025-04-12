import { registerAs } from '@nestjs/config';
import { env } from './env';

export default registerAs('server', () => ({
  port: env.provide<number>('SERVER_PORT', {
    defaultValue: 3000,
    mutators: [(value: string) => parseInt(value, 10)],
  }),
  api_base_url: env.provide<string>('API_BASE_URL', {
    defaultValue: 'http://localhost:3000',
  }),
}));
