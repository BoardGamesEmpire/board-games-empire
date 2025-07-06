import { ArgumentsHost, Catch, Logger } from '@nestjs/common';
import { BaseWsExceptionFilter, WsException } from '@nestjs/websockets';
import * as crypto from 'node:crypto';
import { Socket } from 'socket.io';
import { ErrorCode } from '../constants/error-codes.enum';
import { BaseException } from '../exceptions/base.exception';
import type { WSErrorResponse } from '../interfaces/error-response.interface';

@Catch()
export class GlobalWsExceptionFilter extends BaseWsExceptionFilter {
  private readonly logger = new Logger(GlobalWsExceptionFilter.name);

  override catch(exception: unknown, host: ArgumentsHost) {
    const client = host.switchToWs().getClient<Socket>();
    const errorResponse = this.createWsErrorResponse(exception);

    this.logError(exception, errorResponse, client);

    client.emit('error', errorResponse);
  }

  private createWsErrorResponse(exception: unknown): WSErrorResponse {
    const timestamp = new Date().toISOString();
    const correlationId = this.generateCorrelationId();

    if (exception instanceof BaseException) {
      return {
        errorCode: exception.errorCode,
        message: exception.message,
        timestamp,
        correlationId,
        stack: exception.stack,
        details: exception.details,
      };
    }

    if (exception instanceof WsException) {
      return {
        errorCode: ErrorCode.InvalidInput,
        message: exception.message,
        timestamp,
        correlationId,
        stack: exception.stack,
      };
    }

    return {
      errorCode: ErrorCode.InternalServerError,
      message: 'An unexpected error occurred',
      timestamp,
      correlationId,
      ...(process.env.NODE_ENV === 'development' && {
        details: {
          error: exception instanceof Error ? exception.message : String(exception),
        },
      }),
    };
  }

  private generateCorrelationId(): string {
    return `ws-${Date.now()}-${crypto.randomBytes(16).toString('hex')}`;
  }

  private logError(exception: unknown, errorResponse: WSErrorResponse, client: Socket): void {
    const logContext = {
      correlationId: errorResponse.correlationId,
      errorCode: errorResponse.errorCode,
      userId: (client as any).user?.id,
      socketId: client.id,
    };

    this.logger.error(errorResponse.message, exception instanceof Error ? exception.stack : '', logContext);
  }
}
