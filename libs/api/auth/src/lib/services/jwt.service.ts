import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService as NestJwtService } from '@nestjs/jwt';

@Injectable()
export class JwtService {
  constructor(private jwtService: NestJwtService, private configService: ConfigService) {}

  /**
   * Validate a JWT token
   */
  async validateToken(token: string): Promise<any> {
    try {
      return await this.jwtService.verifyAsync(token, {
        secret: this.configService.get('JWT_SECRET'),
      });
    } catch (error) {
      return null;
    }
  }

  /**
   * Generate a JWT token
   */
  sign(payload: any): string {
    return this.jwtService.sign(payload);
  }
}
