import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { User } from '@prisma/client';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  private readonly logger = new Logger(LocalStrategy.name);

  constructor(private readonly authService: AuthService) {
    super({
      usernameField: 'email',
      passwordField: 'password',
    });
  }

  async validate(username: string, password: string): Promise<User> {
    this.logger.debug(`Authentication attempt for user: ${username}`);

    if (!username || !password) {
      this.logger.warn(`Failed authentication attempt for user: ${username}`);
      throw new UnauthorizedException('Username and password are required')
    }

    const user = await this.authService.validateUser(username, password);
    if (!user) {
      this.logger.warn(`Failed authentication attempt for user: ${username}`);
      throw new UnauthorizedException('Invalid credentials');
    }

    return user;
  }
}
