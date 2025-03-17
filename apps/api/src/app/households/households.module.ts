import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { HouseholdsController } from './households.controller';
import { HouseholdsService } from './households.service';

@Module({
  controllers: [HouseholdsController],
  providers: [HouseholdsService],
  imports: [PrismaModule],
})
export class HouseholdsModule {}
