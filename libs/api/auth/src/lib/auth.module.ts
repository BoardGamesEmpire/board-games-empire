import { PrismaModule } from '@bg-empire/api-prisma';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { AuthController } from './controllers/auth.controller';
import { OidcController } from './controllers/oidc.controller';

import { AuthService } from './services/auth.service';
import { IdentityProviderService } from './services/identity-provider.service';
import { JoseService } from './services/jose.service';
import { JwtService } from './services/jwt.service';
import { OidcService } from './services/oidc.service';

import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';

@Module({
  imports: [
    PrismaModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory(configService: ConfigService) {
        return configService.get('jwt');
      },
    }),
    ConfigModule,
  ],
  controllers: [AuthController, OidcController],
  providers: [AuthService, JwtService, OidcService, IdentityProviderService, JoseService, JwtStrategy, LocalStrategy],
  exports: [AuthService, JwtService, OidcService],
})
export class AuthModule {}
