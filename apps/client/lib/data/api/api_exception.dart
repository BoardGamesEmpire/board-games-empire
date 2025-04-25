import 'package:http_status/http_status.dart';

import '../../blocs/error/error_bloc.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final ErrorType errorType;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    ErrorType? errorType,
  }) : errorType = _determineErrorType(statusCode, errorType);

  static ErrorType _determineErrorType(
    int? statusCode,
    ErrorType? providedType,
  ) {
    if (providedType != null) {
      return providedType;
    }

    if (statusCode == null) {
      return ErrorType.generic;
    }

    if (statusCode == HttpStatusCode.unauthorized ||
        statusCode == HttpStatusCode.forbidden) {
      return ErrorType.auth;
    }

    if (statusCode >= HttpStatusCode.internalServerError && statusCode < 600) {
      return ErrorType.server;
    }

    // 0 or negative indicates network error
    if (statusCode <= 0) {
      return ErrorType.network;
    }

    return ErrorType.generic;
  }

  @override
  String toString() {
    String result = 'ApiException: $message';
    if (statusCode != null) {
      result += ' [Status Code: $statusCode]';
    }
    return result;
  }

  // Helper method to report this error to the ErrorBloc
  void report(ErrorBloc errorBloc, {bool showDialog = false}) {
    switch (errorType) {
      case ErrorType.network:
        errorBloc.add(
          NetworkErrorReported(message, shouldShowDialog: showDialog),
        );
        break;
      case ErrorType.auth:
        errorBloc.add(AuthErrorReported(message, shouldShowDialog: showDialog));
        break;
      case ErrorType.server:
        errorBloc.add(
          ServerErrorReported(message, shouldShowDialog: showDialog),
        );
        break;
      case ErrorType.generic:
      default:
        errorBloc.add(ErrorReported(message, shouldShowDialog: showDialog));
        break;
    }
  }
}
