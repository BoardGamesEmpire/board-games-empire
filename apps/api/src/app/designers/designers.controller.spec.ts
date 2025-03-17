import { Test, TestingModule } from '@nestjs/testing';
import { DesignersController } from './designers.controller';
import { DesignersService } from './designers.service';

describe('DesignersController', () => {
  let controller: DesignersController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DesignersController],
      providers: [DesignersService],
    }).compile();

    controller = module.get<DesignersController>(DesignersController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
