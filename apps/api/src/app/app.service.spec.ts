import { Test } from '@nestjs/testing';

import { PrismaModule } from '@bg-empire/api-prisma';
import { AppService } from './app.service';

describe('AppService', () => {
  let service: AppService;

  beforeAll(async () => {
    const app = await Test.createTestingModule({
      providers: [AppService],
      imports: [PrismaModule],
    }).compile();

    service = app.get<AppService>(AppService);
  });

  describe('getData', () => {
    it('should return site infos', () => {
      expect(service.getData()).toEqual({
        message: 'Welcome to Board Games Empire API!',
        version: '1.0.0',
        documentation: '/api',
      });
    });
  });
});
