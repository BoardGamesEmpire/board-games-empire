export interface ErrorResponse extends WSErrorResponse {
  statusCode: number;
}

export interface WSErrorResponse {
  errorCode: string;
  message: string;
  timestamp: string;
  path?: string;
  correlationId?: string;
  details?: Record<string, any>;
  stack?: string;
}

export interface ValidationErrorDetail {
  field: string;
  constraints: string[];
  value?: any;
}
