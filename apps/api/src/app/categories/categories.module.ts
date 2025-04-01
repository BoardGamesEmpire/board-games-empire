import { PrismaModule } from '@bg-empire/api/prisma';
import { Module } from '@nestjs/common';
import { CategoriesController } from './categories.controller';
import { CategoriesService } from './categories.service';

@Module({
  controllers: [CategoriesController],
  providers: [CategoriesService],
  imports: [PrismaModule],
})
export class CategoriesModule {}
