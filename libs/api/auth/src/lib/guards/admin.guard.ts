import { ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class AdminGuard extends AuthGuard('jwt') {
  constructor() {
    super();
  }

  override canActivate(context: ExecutionContext) {
    console.log('AdminGuard: canActivate called');
    return super.canActivate(context);
  }

  override handleRequest(err: Error, user: any, info: any) {
    console.log('AdminGuard: handleRequest called');

    if (err || !user) {
      throw err || new ForbiddenException('Authentication required');
    }

    // Check if user has Admin role
    // This assumes you have a roles array in your user object
    // You might need to adjust this based on your actual role implementation
    if (!user.roles?.includes('Admin')) {
      throw new ForbiddenException('Admin access required');
    }

    return user;
  }
}
