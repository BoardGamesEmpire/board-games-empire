import { registerAs } from '@nestjs/config';
import { env } from './env';

export default registerAs('throttle', () =>
  env.provideMany<{ ttl: number; limit: number }>([
    {
      keyTo: 'ttl',
      defaultValue: 60,
      mutators: [(value: string) => parseInt(value, 10)],
      key: 'THROTTLE_TTL',
    },
    {
      keyTo: 'limit',
      defaultValue: 20,
      mutators: [(value: string) => parseInt(value, 10)],
      key: 'THROTTLE_LIMIT',
    },
  ]),
);
