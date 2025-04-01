import { ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  override canActivate(context: ExecutionContext) {
    console.log('JwtAuth canActivate called');

    // Check if the route is marked as public
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublic) {
      return true;
    }

    return super.canActivate(context);
  }

  override handleRequest(err: Error, user: any, info: any) {
    console.log('JwtAuth handleRequest called');

    // You can throw an exception based on either "info" or "err" arguments
    if (err || !user) {
      throw err || new UnauthorizedException('Authentication required');
    }

    return user;
  }
}
