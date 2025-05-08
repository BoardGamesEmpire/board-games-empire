import { registerAs } from '@nestjs/config';
import Joi from 'joi';
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
      defaultValue: '1.0.0',
    },
  ]),
);

export const swaggerConfigValidationSchema = {
  SWAGGER_ENABLED: Joi.boolean().default(env.isDevelopment),
  SWAGGER_TITLE: Joi.string().default('Board Games Empire API'),
  SWAGGER_DESCRIPTION: Joi.string().default('RESTful API for Board Games Empire'),
  SWAGGER_VERSION: Joi.string().default('1.0'),
};
