import { PrismaModule } from '@bg-empire/api-prisma';
import { Module } from '@nestjs/common';
import { MechanicsController } from './mechanics.controller';
import { MechanicsService } from './mechanics.service';

@Module({
  controllers: [MechanicsController],
  providers: [MechanicsService],
  imports: [PrismaModule],
})
export class MechanicsModule {}
