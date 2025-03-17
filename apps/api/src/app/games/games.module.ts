import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { GamesController } from './games.controller';
import { GamesService } from './games.service';

@Module({
  controllers: [GamesController],
  providers: [GamesService],
  imports: [PrismaModule],
})
export class GamesModule {}
