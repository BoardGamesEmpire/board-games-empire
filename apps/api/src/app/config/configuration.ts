// apps/api/src/app/config/configuration.ts
export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    url: process.env.DATABASE_URL,
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRATION || '1d',
  },
  throttle: {
    ttl: parseInt(process.env.THROTTLE_TTL, 10) || 60,
    limit: parseInt(process.env.THROTTLE_LIMIT, 10) || 20,
  },
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
    credentials: process.env.CORS_CREDENTIALS === 'true',
  },
  swagger: {
    enabled: process.env.SWAGGER_ENABLED === 'true' || process.env.NODE_ENV !== 'production',
    title: process.env.SWAGGER_TITLE || 'Board Games Empire API',
    description: process.env.SWAGGER_DESCRIPTION || 'RESTful API for Board Games Empire',
    version: process.env.SWAGGER_VERSION || '1.0',
  },
  security: {
    bcryptSaltRounds: parseInt(process.env.BCRYPT_SALT_ROUNDS, 10) || 12,
  },
});
