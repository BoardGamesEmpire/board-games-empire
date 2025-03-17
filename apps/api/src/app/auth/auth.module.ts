import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { UsersModule } from '../users/users.module';
import { AuthService } from './auth.service';
import { strategies } from './strategies';

@Module({
  providers: [AuthService, ...strategies],
  imports: [UsersModule, PassportModule],
})
export class AuthModule {}
