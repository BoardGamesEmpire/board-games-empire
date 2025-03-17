import { Logger, RequestMethod, ValidationPipe, VersioningType } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

async function bootstrap() {
  const globalPrefix = 'api';

  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    logger: environment.production
      ? ['error', 'log', 'warn']
      : ['debug', 'error', 'log', 'verbose', 'warn'],
  });

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
      })
    )
    .setGlobalPrefix(globalPrefix, {
      exclude: [{ path: 'metrics', method: RequestMethod.GET }],
    })
    .enableVersioning({
      defaultVersion: '1',
      type: VersioningType.URI,
    })
    .enableCors();

  const config = new DocumentBuilder()
    .setTitle('Board Games Empire')
    .setDescription('Personal board games collection manager')
    .setVersion('0.1')
    .build();

  const document = SwaggerModule.createDocument(app, config);

  SwaggerModule.setup(globalPrefix, app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  Logger.log(
    `🚀 Application is running on: http://localhost:${port}/${globalPrefix}`
  );
}

bootstrap();
