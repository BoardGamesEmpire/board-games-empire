import { ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {
  constructor() {
    super();
  }

  // Override the canActivate method to customize the behavior
  override canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  // Override the handleRequest method to customize the behavior
  override handleRequest(err: Error, user: any, info: any) {
    console.log('LocalAuth handleRequest called', err, user, info);
    // If there is an error or no user, throw an exception
    if (err || !user) {
      throw err || new UnauthorizedException('Invalid credentials');
    }
    return user;
  }
}
