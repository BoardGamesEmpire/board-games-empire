import { Test, TestingModule } from '@nestjs/testing';
import { MechanicsController } from './mechanics.controller';
import { MechanicsService } from './mechanics.service';

describe('MechanicsController', () => {
  let controller: MechanicsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MechanicsController],
      providers: [MechanicsService],
    }).compile();

    controller = module.get<MechanicsController>(MechanicsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
