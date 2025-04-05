import { PrismaModule } from '@bg-empire/api-prisma';
import { Module } from '@nestjs/common';
import { GamesController } from './games.controller';
import { GamesService } from './games.service';

@Module({
  controllers: [GamesController],
  providers: [GamesService],
  imports: [PrismaModule],
})
export class GamesModule {}
