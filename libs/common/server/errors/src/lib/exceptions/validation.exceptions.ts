import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class ValidationFailedException extends BaseException {
  constructor({ cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ValidationFailed,
      message: 'Validation failed',
      statusCode: HttpStatus.BAD_REQUEST,
      details,
      cause,
    });
  }
}

export class InvalidInputException extends BaseException {
  constructor(message: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.InvalidInput,
      message,
      statusCode: HttpStatus.BAD_REQUEST,
      details,
      cause,
    });
  }
}

export class MissingRequiredFieldException extends BaseException {
  constructor(field: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.MissingRequiredField,
      message: `Required field '${field}' is missing`,
      statusCode: HttpStatus.BAD_REQUEST,
      details: { field, ...details },
      cause,
    });
  }
}
