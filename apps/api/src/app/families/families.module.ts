import { PrismaModule } from '@bg-empire/api/prisma';
import { Module } from '@nestjs/common';
import { FamiliesController } from './families.controller';
import { FamiliesService } from './families.service';

@Module({
  controllers: [FamiliesController],
  providers: [FamiliesService],
  imports: [PrismaModule],
})
export class FamiliesModule {}
