import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { PrismaModule } from './prisma/prisma.module';
import { UsersModule } from './users/users.module';
import { CategoriesModule } from './categories/categories.module';
import { PublishersModule } from './publishers/publishers.module';
import { GamesModule } from './games/games.module';
import { DesignersModule } from './designers/designers.module';
import { FamiliesModule } from './families/families.module';
import { MechanicsModule } from './mechanics/mechanics.module';
import { GameTypesModule } from './game-types/game-types.module';
import { HouseholdsModule } from './households/households.module';
import { LanguagesModule } from './languages/languages.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    PrismaModule,
    PrometheusModule.register({
      defaultLabels: { app: 'BoardGamesEmpire' },
      defaultMetrics: { enabled: true },
    }),
    AuthModule,
    UsersModule,
    CategoriesModule,
    PublishersModule,
    GamesModule,
    DesignersModule,
    FamiliesModule,
    MechanicsModule,
    GameTypesModule,
    HouseholdsModule,
    LanguagesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
