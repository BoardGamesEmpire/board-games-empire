import { Test, TestingModule } from '@nestjs/testing';
import { DesignersService } from './designers.service';

describe('DesignersService', () => {
  let service: DesignersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DesignersService],
    }).compile();

    service = module.get<DesignersService>(DesignersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
