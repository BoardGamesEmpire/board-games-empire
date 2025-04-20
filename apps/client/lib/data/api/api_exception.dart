class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() {
    String result = 'ApiException: $message';
    if (statusCode != null) {
      result += ' [Status Code: $statusCode]';
    }
    return result;
  }
}
