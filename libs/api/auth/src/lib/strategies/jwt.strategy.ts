import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { DateTime } from 'luxon';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly configService: ConfigService, private readonly prisma: PrismaService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
      select: {
        id: true,
        username: true,
        firstName: true,
        lastName: true,
        avatar: true,
        createdAt: true,
        updatedAt: true,

        authentication: {
          select: {
            id: true,
            email: true,
            authStrategy: true,
            isExternalUser: true,
            emailVerified: true,
          },
        },
      },
    });

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    if (payload.sid) {
      const session = await this.prisma.userSession.findFirst({
        where: {
          id: payload.sid,
          isValid: true,
          expiresAt: { gt: new Date() },
        },
      });

      if (!session) {
        throw new UnauthorizedException('Session has expired or been revoked');
      }

      const tenMinutesAgo = DateTime.now().minus({ minutes: 10 }).toJSDate();
      if (session.lastActive < tenMinutesAgo) {
        await this.prisma.userSession.update({
          where: { id: payload.sid },
          data: { lastActive: new Date() },
        });
      }
    }

    return user;
  }
}
