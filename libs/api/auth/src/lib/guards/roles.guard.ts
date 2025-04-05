import { ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { ROLES_KEY } from '../decorators/roles.decorator';

@Injectable()
export class RolesGuard extends AuthGuard('jwt') {
  constructor(private reflector: Reflector) {
    super();
  }

  override async canActivate(context: ExecutionContext) {
    console.log('RolesGuard: canActivate called');

    // First ensure the user is authenticated
    const authenticated = await super.canActivate(context);
    if (!authenticated) {
      return false;
    }

    // Get the required roles from the handler or controller
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    // If no roles are required, allow access
    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    // Get the user from the request
    const { user } = context.switchToHttp().getRequest();

    // Check if the user has the required role
    // This assumes you have a roles array in your user object
    // You might need to adjust this based on your actual role implementation
    return requiredRoles.some((role) => user.roles && user.roles.includes(role));
  }

  override handleRequest(err: Error, user: any, info: any) {
    console.log('RolesGuard: handleRequest called');
    if (err || !user) {
      throw err || new ForbiddenException('Authentication required');
    }

    return user;
  }
}
