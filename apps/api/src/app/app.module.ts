import { AuthModule, JwtAuthGuard } from '@bg-empire/api/auth';
import { PrismaModule } from '@bg-empire/api/prisma';
import { UsersModule } from '@bg-empire/api/users';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CategoriesModule } from './categories/categories.module';
import configuration from './config/configuration';
import { validationSchema } from './config/validation-schema';
import { DesignersModule } from './designers/designers.module';
import { FamiliesModule } from './families/families.module';
import { GamesModule } from './games/games.module';
import { HouseholdsModule } from './households/households.module';
import { LanguagesModule } from './languages/languages.module';
import { MechanicsModule } from './mechanics/mechanics.module';
import { PublishersModule } from './publishers/publishers.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validationSchema,
    }),

    // Rate limiting
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        throttlers: [
          {
            name: 'default',
            ttl: config.get<number>('throttle.ttl'),
            limit: config.get<number>('throttle.limit'),
          },
        ],
      }),
    }),

    // Database
    PrismaModule,
    PrometheusModule.register({
      defaultLabels: { app: 'BoardGamesEmpire' },
      defaultMetrics: { enabled: true },
    }),

    // Feature modules
    AuthModule,
    UsersModule,
    CategoriesModule,
    PublishersModule,
    GamesModule,
    DesignersModule,
    FamiliesModule,
    MechanicsModule,
    HouseholdsModule,
    LanguagesModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    // Global guards
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
  ],
})
export class AppModule {}
