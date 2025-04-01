import { ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {
  constructor() {
    super();
  }

  // Override the canActivate method to customize the behavior
  override canActivate(context: ExecutionContext) {
    console.log('LocalAuth canActivate called');
    // Call the default canActivate method
    const canActivate = super.canActivate(context);
    // If you want to add additional logic, you can do it here
    return canActivate;
  }

  // Override the handleRequest method to customize the behavior
  override handleRequest(err: Error, user: any, info: any) {
    console.log('LocalAuth handleRequest called');
    // If there is an error or no user, throw an exception
    if (err || !user) {
      throw err || new UnauthorizedException('Invalid credentials');
    }
    return user;
  }
}
