import database, { databaseConfigValidationSchema } from './database.config';
import graphql, { graphqlConfigValidationSchema } from './graphql.config';
import jwt, { jwtConfigValidationSchema } from './jwt.config';
import rabbit from './rabbitmq.config';
import security, { securityConfigValidationSchema } from './security.config';
import server, { serverConfigValidationSchema } from './server.config';
import swagger, { swaggerConfigValidationSchema } from './swagger.config';
import throttle, { throttleConfigValidationSchema } from './throttle.config';

export const configuration = [server, database, swagger, graphql, jwt, throttle, security, rabbit];

export const configurationValidationSchema = {
  ...serverConfigValidationSchema,
  ...databaseConfigValidationSchema,
  ...swaggerConfigValidationSchema,
  ...graphqlConfigValidationSchema,
  ...jwtConfigValidationSchema,
  ...throttleConfigValidationSchema,
  ...securityConfigValidationSchema,
};

export { env } from './env';
