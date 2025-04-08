import { ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { from, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  override canActivate(context: ExecutionContext) {
    console.log('JwtAuth canActivate called');

    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    console.log(request.headers, 'HEADERS');

    const result = super.canActivate(context);
    const observable = typeof result === 'boolean' ? of(result) : from(result);
    return observable.pipe(tap((result) => console.log('canActivate result:', result)));
  }

  override handleRequest(err: Error, user: any, info: any) {
    console.log('JwtAuth handleRequest called', user, err, info);

    if (err || !user) {
      throw err || new UnauthorizedException('Authentication required');
    }

    return user;
  }
}
