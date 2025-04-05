import { AuthModule } from '@bg-empire/api/auth';
import { PrismaModule } from '@bg-empire/api/prisma';
import { Module } from '@nestjs/common';
import { UsersController } from './controllers/users.controller';
import { UserPreferencesService } from './services/user-preferences.service';
import { UsersService } from './services/users.service';

// This module is responsible for managing users and their preferences.
@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [UsersController],
  providers: [UsersService, UserPreferencesService],
  exports: [UsersService, UserPreferencesService],
})
export class UsersModule {}
