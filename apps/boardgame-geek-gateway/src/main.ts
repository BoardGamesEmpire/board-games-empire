import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app/app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.startAllMicroservices();

  Logger.log(`🚀 Application Boardgames Geek Gateway is running`);
}

bootstrap();
