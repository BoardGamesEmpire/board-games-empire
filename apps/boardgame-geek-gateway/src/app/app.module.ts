import { NestConfigModule } from '@bge/config';
import { QueueModule } from '@bge/microservices-queue';
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [QueueModule, NestConfigModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
