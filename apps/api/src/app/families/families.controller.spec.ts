import { Test, TestingModule } from '@nestjs/testing';
import { FamiliesController } from './families.controller';
import { FamiliesService } from './families.service';

describe('FamiliesController', () => {
  let controller: FamiliesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FamiliesController],
      providers: [FamiliesService],
    }).compile();

    controller = module.get<FamiliesController>(FamiliesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
