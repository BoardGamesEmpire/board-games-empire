import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { GameTypesController } from './game-types.controller';
import { GameTypesService } from './game-types.service';

@Module({
  controllers: [GameTypesController],
  providers: [GameTypesService],
  imports: [PrismaModule],
})
export class GameTypesModule {}
