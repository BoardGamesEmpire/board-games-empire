import { Test, TestingModule } from '@nestjs/testing';
import { GameTypesService } from './game-types.service';

describe('GameTypesService', () => {
  let service: GameTypesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [GameTypesService],
    }).compile();

    service = module.get<GameTypesService>(GameTypesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
