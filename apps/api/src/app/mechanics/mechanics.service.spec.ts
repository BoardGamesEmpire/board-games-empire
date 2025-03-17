import { Test, TestingModule } from '@nestjs/testing';
import { MechanicsService } from './mechanics.service';

describe('MechanicsService', () => {
  let service: MechanicsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MechanicsService],
    }).compile();

    service = module.get<MechanicsService>(MechanicsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
