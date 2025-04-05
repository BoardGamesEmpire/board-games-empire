import { PrismaModule } from '@bg-empire/api-prisma';
import { Module } from '@nestjs/common';
import { DesignersController } from './designers.controller';
import { DesignersService } from './designers.service';

@Module({
  controllers: [DesignersController],
  providers: [DesignersService],
  imports: [PrismaModule],
})
export class DesignersModule {}
