import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { PublishersController } from './publishers.controller';
import { PublishersService } from './publishers.service';

@Module({
  controllers: [PublishersController],
  providers: [PublishersService],
  imports: [PrismaModule],
})
export class PublishersModule {}
