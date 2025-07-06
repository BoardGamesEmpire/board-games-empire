import { HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException, CauseDetails } from './base.exception';

export class ExternalServiceErrorException extends BaseException {
  constructor(service: string, message?: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ExternalServiceError,
      message: message || `Error occurred while communicating with ${service}`,
      statusCode: HttpStatus.BAD_GATEWAY,
      details: { service, ...details },
      cause,
    });
  }
}

export class GatewayTimeoutException extends BaseException {
  constructor(service: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.GatewayTimeout,
      message: `Request to ${service} timed out`,
      statusCode: HttpStatus.GATEWAY_TIMEOUT,
      details: { service, ...details },
      cause,
    });
  }
}

export class ServiceUnavailableException extends BaseException {
  constructor(service: string, { cause, details }: CauseDetails = {}) {
    super({
      errorCode: ErrorCode.ServiceUnavailable,
      message: `${service} is currently unavailable`,
      statusCode: HttpStatus.SERVICE_UNAVAILABLE,
      details: { service, ...details },
      cause,
    });
  }
}
