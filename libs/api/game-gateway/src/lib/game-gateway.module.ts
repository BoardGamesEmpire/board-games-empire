import { Module } from '@nestjs/common';
import { GameGatewayController } from './controllers/game-gateway.controller';
import { GameGatewayService } from './services/game-gateway.service';

@Module({
  controllers: [GameGatewayController],
  providers: [GameGatewayService],
  exports: [GameGatewayService],
})
export class GameGatewayModule {}
