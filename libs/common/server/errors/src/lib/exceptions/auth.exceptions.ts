import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class InvalidCredentialsException extends BaseException {
  constructor({ cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.InvalidCredentials,
      message: 'Invalid credentials provided',
      statusCode: HttpStatus.UNAUTHORIZED,
      details,
      cause,
    });
  }
}

export class InsufficientPermissionsException extends BaseException {
  constructor(action: string, resource?: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.InsufficientPermissions,
      message: `Insufficient permissions to ${action}${resource ? ` ${resource}` : ''}`,
      statusCode: HttpStatus.FORBIDDEN,
      details: { action, resource, ...details },
      cause,
    });
  }
}
export class InvalidTokenException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.TokenInvalid,
      message,
      statusCode: HttpStatus.UNAUTHORIZED,
      details,
      cause,
    });
  }
}

export class TokenExpiredException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.TokenExpired,
      message,
      statusCode: HttpStatus.UNAUTHORIZED,
      details,
      cause,
    });
  }
}

export class AccountLockedException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.AccountLocked,
      message,
      statusCode: HttpStatus.FORBIDDEN,
      details,
      cause,
    });
  }
}

export class EmailNotVerifiedException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.EmailNotVerified,
      message,
      statusCode: HttpStatus.FORBIDDEN,
      details,
      cause,
    });
  }
}

export class SessionExpiredException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.SessionExpired,
      message,
      statusCode: HttpStatus.UNAUTHORIZED,
      details,
      cause,
    });
  }
}
