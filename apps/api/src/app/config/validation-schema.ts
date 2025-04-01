import Joi from 'joi';

export const validationSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
  PORT: Joi.number().default(3000),
  DATABASE_URL: Joi.string().required(),
  JWT_SECRET: Joi.string().required(),
  JWT_EXPIRATION: Joi.string().default('1d'),
  THROTTLE_TTL: Joi.number().default(60),
  THROTTLE_LIMIT: Joi.number().default(20),
  CORS_ORIGIN: Joi.string().default('*'),
  CORS_CREDENTIALS: Joi.boolean().default(false),
  SWAGGER_ENABLED: Joi.boolean().default(true),
  SWAGGER_TITLE: Joi.string().default('Board Games Empire API'),
  SWAGGER_DESCRIPTION: Joi.string().default('RESTful API for Board Games Empire'),
  SWAGGER_VERSION: Joi.string().default('1.0'),
  BCRYPT_SALT_ROUNDS: Joi.number().default(12),
});
