import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService as NestJwtService } from '@nestjs/jwt';

@Injectable()
export class JwtService {
  constructor(private jwtService: NestJwtService, private configService: ConfigService) {}

  /**
   * Validate a JWT token
   */
  async validateToken(token: string) {
    try {
      return await this.jwtService.verifyAsync(token, {
        secret: this.configService.get<string>('JWT_SECRET'),
      });
    } catch (error) {
      return null;
    }
  }

  /**
   * Generate a JWT token
   */
  sign(payload: Record<string, any>): string {
    return this.jwtService.sign(payload);
  }
}
