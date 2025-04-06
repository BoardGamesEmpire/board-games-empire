import { Test, TestingModule } from '@nestjs/testing';

import { PrismaModule } from '@bg-empire/api-prisma';
import { AppController } from './app.controller';
import { AppService } from './app.service';

describe('AppController', () => {
  let app: TestingModule;

  beforeAll(async () => {
    app = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
      imports: [PrismaModule],
    }).compile();
  });

  describe('getData', () => {
    it('should return site infos', () => {
      const appController = app.get<AppController>(AppController);
      expect(appController.getData()).toEqual({
        message: 'Welcome to Board Games Empire API!',
        version: '1.0.0',
        documentation: '/api',
      });
    });
  });
});
