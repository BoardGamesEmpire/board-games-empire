import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { User } from '@prisma/client';
import { Strategy } from 'passport-local';
import { AuthService } from '../services/auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  private readonly logger = new Logger(LocalStrategy.name);

  constructor(private readonly authService: AuthService) {
    super({
      usernameField: 'email',
      passwordField: 'password',
    });
  }

  async validate(email: string, password: string): Promise<User> {
    this.logger.debug(`Authentication attempt for user: ${email}`);

    if (!email || !password) {
      this.logger.warn(`Failed authentication attempt for user: ${email}`);
      throw new UnauthorizedException('Email and password are required');
    }

    const user = await this.authService.validateUser(email, password);
    if (!user) {
      this.logger.warn(`Failed authentication attempt for user: ${email}`);
      throw new UnauthorizedException('Invalid credentials');
    }

    return user;
  }
}
