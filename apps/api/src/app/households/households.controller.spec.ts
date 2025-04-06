import { PrismaModule } from '@bg-empire/api-prisma';
import { Test, TestingModule } from '@nestjs/testing';
import { HouseholdsController } from './households.controller';
import { HouseholdsService } from './households.service';

describe('HouseholdsController', () => {
  let controller: HouseholdsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HouseholdsController],
      providers: [HouseholdsService],
      imports: [PrismaModule],
    }).compile();

    controller = module.get<HouseholdsController>(HouseholdsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
