import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class ResourceNotFoundException extends BaseException {
  constructor(resourceType: string, resourceId?: string | number, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ResourceNotFound,
      message: `${resourceType}${resourceId ? ` with ID ${resourceId}` : ''} not found`,
      statusCode: HttpStatus.NOT_FOUND,
      details: { resourceType, resourceId, ...details },
      cause,
    });
  }
}

export class ResourceAlreadyExistsException extends BaseException {
  constructor(resourceType: string, criteria?: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ResourceAlreadyExists,
      message: `${resourceType}${criteria ? ` with ${criteria}` : ''} already exists`,
      statusCode: HttpStatus.CONFLICT,
      details: { resourceType, criteria, ...details },
      cause,
    });
  }
}

export class ResourceConflictException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ResourceConflict,
      message,
      statusCode: HttpStatus.CONFLICT,
      details,
      cause,
    });
  }
}

export class ResourceLockedException extends BaseException {
  constructor(resourceType: string, resourceId?: string | number, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ResourceLocked,
      message: `${resourceType}${resourceId ? ` with ID ${resourceId}` : ''} is locked`,
      statusCode: HttpStatus.LOCKED,
      details: { resourceType, resourceId, ...details },
      cause,
    });
  }
}
