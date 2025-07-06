import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class BusinessRuleViolationException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.BusinessRuleViolation,
      message,
      statusCode: HttpStatus.BAD_REQUEST,
      details,
      cause,
    });
  }
}

export class OperationNotAllowedException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.OperationNotAllowed,
      message,
      statusCode: HttpStatus.FORBIDDEN,
      details,
      cause,
    });
  }
}

export class QuotaExceededException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.QuotaExceeded,
      message,
      statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
      details,
      cause,
    });
  }
}

export class RateLimitExceededException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.RateLimitExceeded,
      message,
      statusCode: HttpStatus.TOO_MANY_REQUESTS,
      details,
      cause,
    });
  }
}
