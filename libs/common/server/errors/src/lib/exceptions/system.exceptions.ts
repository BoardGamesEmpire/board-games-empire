import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class InternalServerErrorException extends BaseException {
  constructor(message?: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.InternalServerError,
      message: message || 'Internal server error occurred',
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      details,
      cause,
    });
  }
}

export class DatabaseErrorException extends BaseException {
  constructor(message?: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.DatabaseError,
      message: message || 'Database operation failed',
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      details,
      cause,
    });
  }
}

export class ConfigurationErrorException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ConfigurationError,
      message,
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      details,
      cause,
    });
  }
}

export class NotImplementedException extends BaseException {
  constructor(feature: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.NotImplemented,
      message: `${feature} is not implemented yet`,
      statusCode: HttpStatus.NOT_IMPLEMENTED,
      details: { feature, ...details },
      cause,
    });
  }
}
