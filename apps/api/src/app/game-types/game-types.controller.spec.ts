import { Test, TestingModule } from '@nestjs/testing';
import { GameTypesController } from './game-types.controller';
import { GameTypesService } from './game-types.service';

describe('GameTypesController', () => {
  let controller: GameTypesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [GameTypesController],
      providers: [GameTypesService],
    }).compile();

    controller = module.get<GameTypesController>(GameTypesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
