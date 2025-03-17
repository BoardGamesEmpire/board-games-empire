import { Test, TestingModule } from '@nestjs/testing';
import { HouseholdsService } from './households.service';

describe('HouseholdsService', () => {
  let service: HouseholdsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [HouseholdsService],
    }).compile();

    service = module.get<HouseholdsService>(HouseholdsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
