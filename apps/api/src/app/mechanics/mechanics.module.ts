import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { MechanicsController } from './mechanics.controller';
import { MechanicsService } from './mechanics.service';

@Module({
  controllers: [MechanicsController],
  providers: [MechanicsService],
  imports: [PrismaModule],
})
export class MechanicsModule {}
