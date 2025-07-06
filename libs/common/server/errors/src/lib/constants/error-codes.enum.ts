export enum ErrorCode {
  // Authentication & Authorization
  InvalidCredentials = 'AUTH001',
  TokenExpired = 'AUTH002',
  TokenInvalid = 'AUTH003',
  InsufficientPermissions = 'AUTH004',
  AccountLocked = 'AUTH005',
  EmailNotVerified = 'AUTH006',
  SessionExpired = 'AUTH007',

  // Validation
  ValidationFailed = 'VAL001',
  InvalidInput = 'VAL002',
  MissingRequiredField = 'VAL003',

  // Resource Management
  ResourceNotFound = 'RES001',
  ResourceAlreadyExists = 'RES002',
  ResourceConflict = 'RES003',
  ResourceLocked = 'RES004',

  // Business Logic
  BusinessRuleViolation = 'BUS001',
  OperationNotAllowed = 'BUS002',
  QuotaExceeded = 'BUS003',
  RateLimitExceeded = 'BUS004',

  // External Services
  ExternalServiceError = 'EXT001',
  GatewayTimeout = 'EXT002',
  ServiceUnavailable = 'EXT003',

  // System
  InternalServerError = 'SYS001',
  DatabaseError = 'SYS002',
  ConfigurationError = 'SYS003',
  NotImplemented = 'SYS004',
}
