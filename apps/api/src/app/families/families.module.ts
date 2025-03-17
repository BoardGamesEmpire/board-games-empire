import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FamiliesController } from './families.controller';
import { FamiliesService } from './families.service';

@Module({
  controllers: [FamiliesController],
  providers: [FamiliesService],
  imports: [PrismaModule],
})
export class FamiliesModule {}
