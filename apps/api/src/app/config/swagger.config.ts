import { registerAs } from '@nestjs/config';
import { env } from './env';
import { isTrue } from './helpers/helpers';

export interface SwaggerConfig {
  basePath: string;
  description: string;
  enabled: boolean;
  title: string;
  version: string;
}

export default registerAs('swagger', () =>
  env.provideMany<SwaggerConfig>([
    {
      key: 'SWAGGER_ENABLED',
      keyTo: 'enabled',
      defaultValue: env.isDevelopment,
      mutators: [isTrue],
    },
    {
      key: 'SWAGGER_TITLE',
      keyTo: 'title',
      defaultValue: 'Board Games Empire API',
    },
    {
      key: 'SWAGGER_DESCRIPTION',
      keyTo: 'description',
      defaultValue: 'RESTful API for Board Games Empire',
    },
    {
      key: 'SWAGGER_VERSION',
      keyTo: 'version',
      defaultValue: '1.0',
    },
  ]),
);
