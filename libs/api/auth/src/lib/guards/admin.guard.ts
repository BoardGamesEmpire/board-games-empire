import { ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class AdminGuard extends AuthGuard('jwt') {
  constructor() {
    super();
  }

  override canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  override handleRequest(err: Error, user: any, info: any) {
    if (err || !user) {
      throw err || new ForbiddenException('Authentication required');
    }

    if (!user.roles?.includes('Admin')) {
      throw new ForbiddenException('Admin access required');
    }

    return user;
  }
}
