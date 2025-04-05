import { Logger, RequestMethod, ValidationPipe, VERSION_NEUTRAL, VersioningType } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import compression from 'compression';
import helmet from 'helmet';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

async function bootstrap() {
  const globalPrefix = 'api';

  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: environment.production ? ['error', 'log', 'warn'] : ['debug', 'error', 'log', 'verbose', 'warn'],
  });

  const configService = app.get(ConfigService);

  app
    .useGlobalPipes(
      new ValidationPipe({
        forbidNonWhitelisted: true,
        transform: true,
        whitelist: true,
        validationError: {
          target: false,
          value: false,
        },
      }),
    )
    .use(helmet())
    .use(compression())
    .setGlobalPrefix(globalPrefix, {
      exclude: [
        {
          version: ['1'],
          path: 'metrics',
          method: RequestMethod.GET,
        },
        {
          version: VERSION_NEUTRAL,
          path: 'health',
          method: RequestMethod.GET,
        },
      ],
    })
    .enableVersioning({
      defaultVersion: '1',
      type: VersioningType.URI,
    })
    .enableCors({
      origin: configService.get('cors.origin'),
      credentials: configService.get('cors.credentials'),
    });

  if (configService.get('swagger.enabled')) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle(configService.get('swagger.title'))
      .setDescription(configService.get('swagger.description'))
      .setVersion(configService.get('swagger.version'))
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup(globalPrefix, app, document);
  }

  const port = configService.get('port');
  await app.listen(port);

  Logger.log(`🚀 Application is running on: http://localhost:${port}/${globalPrefix}`);
}

bootstrap();
