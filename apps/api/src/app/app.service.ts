import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  getData() {
    return {
      message: 'Welcome to Board Games Empire API!',
      version: '1.0.0',
      documentation: '/api',
    };
  }

  async health() {
    let dbStatus = 'ok';
    let dbError = null;

    try {
      await this.prisma.$queryRaw`SELECT 1`;
    } catch (error) {
      dbStatus = 'error';
      dbError = error.message;
    }

    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      services: {
        database: {
          status: dbStatus,
          error: dbError,
        },
      },
    };
  }
}
