import { PrismaModule } from '@bg-empire/api/prisma';
import { Module } from '@nestjs/common';
import { PublishersController } from './publishers.controller';
import { PublishersService } from './publishers.service';

@Module({
  controllers: [PublishersController],
  providers: [PublishersService],
  imports: [PrismaModule],
})
export class PublishersModule {}
