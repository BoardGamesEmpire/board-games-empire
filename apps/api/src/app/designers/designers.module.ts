import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DesignersController } from './designers.controller';
import { DesignersService } from './designers.service';

@Module({
  controllers: [DesignersController],
  providers: [DesignersService],
  imports: [PrismaModule],
})
export class DesignersModule {}
