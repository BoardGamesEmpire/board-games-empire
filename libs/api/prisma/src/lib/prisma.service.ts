// libs/api/prisma/src/lib/prisma.service.ts
import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    super({
      log:
        process.env.NODE_ENV === 'development' || !process.env.NODE_ENV
          ? ['query', 'info', 'warn', 'error']
          : ['error'],
    });
  }

  public async onModuleInit() {
    try {
      await this.$connect();
    } catch (error) {
      Logger.error(error, PrismaService.name);
      throw error;
    }
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  /**
   * Helper method to clean the database during testing
   * Should only be used in testing environment
   */
  protected async cleanDatabase() {
    // TODO: additional protection with test env token
    if (process.env.NODE_ENV !== 'test') {
      throw new Error('This method is only available in test environment');
    }

    // Get all table names from the database
    const tables = await this.$queryRaw<
      Array<{ tablename: string }>
    >`SELECT tablename FROM pg_tables WHERE schemaname = 'public'`;

    // Disable foreign key constraints
    await this.$executeRaw`SET session_replication_role = 'replica';`;

    // Truncate all tables
    for (const { tablename } of tables) {
      if (tablename !== '_prisma_migrations') {
        try {
          await this.$executeRawUnsafe(`TRUNCATE TABLE "public"."${tablename}" CASCADE;`);
        } catch (error) {
          console.error(`Error truncating table ${tablename}:`, error);
        }
      }
    }

    // Re-enable foreign key constraints
    await this.$executeRaw`SET session_replication_role = 'origin';`;
  }
}
