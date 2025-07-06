import { HttpException, HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';

export interface CauseDetails {
  cause?: Error;
  details?: Record<string, any>;
}

export interface BaseExceptionOptions extends CauseDetails {
  errorCode: ErrorCode;
  message: string;
  statusCode?: HttpStatus;
}

export class BaseException extends HttpException {
  public readonly errorCode: ErrorCode;
  public readonly details?: Record<string, any>;
  public override readonly cause: Error;

  constructor(options: BaseExceptionOptions) {
    const {
      errorCode,
      message,
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR,
      details,
      cause = new Error('An Error Occurred'),
    } = options;

    super(
      {
        errorCode,
        message,
        details,
      },
      statusCode,
      { cause },
    );

    this.errorCode = errorCode;
    this.details = details;
    this.cause = cause;

    Object.setPrototypeOf(this, BaseException.prototype);
  }
}
