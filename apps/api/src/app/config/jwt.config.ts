import { registerAs } from '@nestjs/config';
import { JwtModuleOptions } from '@nestjs/jwt';
import type { EnvManyResult } from '@status/envirator';
import { env } from './env';
import { removeUndefinedFields, splitTrimFilter } from './helpers/helpers';

function shape(record: EnvManyResult): JwtModuleOptions {
  return removeUndefinedFields({
    secret: record.secret,
    signOptions: {
      expiresIn: record.expiresIn,
      algorithm: record.algorithm,
      audience: record.audience,
      issuer: record.issuer,
    },
    verifyOptions: {
      ignoreExpiration: false,
    },
  });
}

export default registerAs('jwt', () =>
  env.provideMany(
    [
      {
        keyTo: 'secret',
        key: 'JWT_SECRET',
      },
      {
        keyTo: 'expiresIn',
        key: 'JWT_EXPIRATION',
        defaultValue: '1d',
      },
      {
        keyTo: 'algorithm',
        key: 'JWT_ALGORITHM',
        defaultValue: 'HS256',
      },
      {
        keyTo: 'audience',
        key: 'JWT_AUDIENCE',
        defaultValue: [],
        mutators: [splitTrimFilter],
        warnOnly: true,
      },
      {
        keyTo: 'issuer',
        key: 'JWT_ISSUER',
        warnOnly: true,
      },
    ],
    shape,
  ),
);
