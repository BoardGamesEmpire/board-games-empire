import { PrismaModule } from '@bg-empire/api-prisma';
import { Test, TestingModule } from '@nestjs/testing';
import { PublishersService } from './publishers.service';

describe('PublishersService', () => {
  let service: PublishersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PublishersService],
      imports: [PrismaModule],
    }).compile();

    service = module.get<PublishersService>(PublishersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
