import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import Joi from 'joi';
import process from 'node:process';
import { configuration, configurationValidationSchema, env } from './configs';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: [`${process.cwd()}/env/.env.${process.env.NODE_ENV}`],
      load: [...configuration],
      cache: true,
      isGlobal: true,
      expandVariables: true,
      validationSchema: Joi.object(configurationValidationSchema),
      validationOptions: {
        abortEarly: true,
        cache: !env.isProduction,
        debug: !env.isProduction,
        stack: !env.isProduction,
      },
    }),
  ],
  providers: [ConfigService],
  exports: [ConfigService],
})
export class NestConfigModule {}
