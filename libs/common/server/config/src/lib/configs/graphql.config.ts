import { registerAs } from '@nestjs/config';
import Joi from 'joi';
import * as path from 'node:path';
import process from 'node:process';
import { env } from './env';
import { isTrue } from './helpers/helpers';

export interface GraphQLConfig {
  debug: boolean;
  playground: boolean;
  sortSchema: boolean;
  autoSchemaFile: boolean | string;
}

export default registerAs('graphql', () =>
  env.provideMany<GraphQLConfig>([
    {
      keyTo: 'debug',
      mutators: isTrue,
      key: 'GRAPHQL_DEBUG',
      defaultValue: env.isDevelopment,
    },
    {
      mutators: isTrue,
      defaultValue: true,
      keyTo: 'playground',
      key: 'GRAPHQL_PLAYGROUND',
    },
    {
      mutators: isTrue,
      key: 'GRAPHQL_SORT',
      keyTo: 'sortSchema',
      defaultValue: env.isDevelopment,
    },
    {
      key: 'GRAPHQL_SCHEMA',
      keyTo: 'autoSchemaFile',
      defaultValue: env.isProduction || path.join(process.cwd(), 'apps/api/schema.gql'),
    },
  ]),
);

export const graphqlConfigValidationSchema = {
  GRAPHQL_DEBUG: Joi.boolean().default(env.isDevelopment),
  GRAPHQL_PLAYGROUND: Joi.boolean().default(env.isDevelopment),
  GRAPHQL_SORT: Joi.boolean().default(false),
  GRAPHQL_SCHEMA: Joi.string().default(''),
};
