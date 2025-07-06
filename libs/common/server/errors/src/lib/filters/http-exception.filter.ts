import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus, Logger } from '@nestjs/common';
import type { Request, Response } from 'express';
import * as crypto from 'node:crypto';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException } from '../exceptions/base.exception';
import { ErrorResponse, ValidationErrorDetail } from '../interfaces/error-response.interface';

@Catch()
export class GlobalHttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalHttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const errorResponse = this.createErrorResponse(exception, request);

    this.logError(exception, errorResponse, request);

    response.status(errorResponse.statusCode).json(errorResponse);
  }

  private createErrorResponse(exception: unknown, request: Request): ErrorResponse {
    const timestamp = new Date().toISOString();
    const path = request.url;
    const correlationId = (request.headers['x-correlation-id'] as string) || this.generateCorrelationId();

    // Handle different exception types
    if (exception instanceof BaseException) {
      return {
        statusCode: exception.getStatus(),
        errorCode: exception.errorCode,
        message: exception.message,
        timestamp,
        path,
        correlationId,
        details: exception.details,
        ...(process.env.NODE_ENV === 'development' && { stack: exception.stack }),
      };
    }

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const response = exception.getResponse();

      // Handle ValidationPipe errors
      if (status === HttpStatus.BAD_REQUEST && typeof response === 'object') {
        const validationResponse = response as any;
        if (validationResponse.message && Array.isArray(validationResponse.message)) {
          return {
            statusCode: status,
            errorCode: ErrorCode.ValidationFailed,
            message: 'Validation failed',
            timestamp,
            path,
            correlationId,
            details: {
              errors: this.formatValidationErrors(validationResponse.message),
            },
          };
        }
      }

      return {
        statusCode: status,
        errorCode: this.mapStatusToErrorCode(status),
        message: exception.message,
        timestamp,
        path,
        correlationId,
        ...(process.env.NODE_ENV === 'development' && { stack: exception.stack }),
      };
    }

    // Handle unknown errors
    return {
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      errorCode: ErrorCode.InternalServerError,
      message: 'An unexpected error occurred',
      timestamp,
      path,
      correlationId,
      ...(process.env.NODE_ENV === 'development' && {
        details: {
          error: exception instanceof Error ? exception.message : String(exception),
        },
        stack: exception instanceof Error ? exception.stack : undefined,
      }),
    };
  }

  private formatValidationErrors(messages: string[]): ValidationErrorDetail[] {
    const errors: ValidationErrorDetail[] = [];
    const errorMap = new Map<string, string[]>();

    messages.forEach((message) => {
      // Extract field name from validation message
      const match = message.match(/^(\w+)\s/);
      const field = match ? match[1] : 'unknown';

      if (!errorMap.has(field)) {
        errorMap.set(field, []);
      }

      errorMap.get(field)!.push(message);
    });

    errorMap.forEach((constraints, field) => {
      errors.push({ field, constraints });
    });

    return errors;
  }

  private mapStatusToErrorCode(status: HttpStatus): ErrorCode {
    const statusMap: Record<number, ErrorCode> = {
      [HttpStatus.BAD_REQUEST]: ErrorCode.InvalidInput,
      [HttpStatus.UNAUTHORIZED]: ErrorCode.InvalidCredentials,
      [HttpStatus.FORBIDDEN]: ErrorCode.InsufficientPermissions,
      [HttpStatus.NOT_FOUND]: ErrorCode.ResourceNotFound,
      [HttpStatus.CONFLICT]: ErrorCode.ResourceConflict,
      [HttpStatus.UNPROCESSABLE_ENTITY]: ErrorCode.BusinessRuleViolation,
      [HttpStatus.INTERNAL_SERVER_ERROR]: ErrorCode.InternalServerError,
    };

    return statusMap[status] || ErrorCode.InternalServerError;
  }

  private generateCorrelationId(): string {
    return `${Date.now()}-${crypto.randomBytes(16).toString('hex')}`;
  }

  private logError(exception: unknown, errorResponse: ErrorResponse, request: Request): void {
    const logContext = {
      correlationId: errorResponse.correlationId,
      method: request.method,
      url: request.url,
      statusCode: errorResponse.statusCode,
      errorCode: errorResponse.errorCode,
      userId: (request as any).user?.id,
      ip: request.ip,
      userAgent: request.headers['user-agent'],
    };

    if (errorResponse.statusCode >= 500) {
      this.logger.error(errorResponse.message, exception instanceof Error ? exception.stack : '', logContext);
    } else if (errorResponse.statusCode >= 400) {
      this.logger.warn(errorResponse.message, logContext);
    }
  }
}
