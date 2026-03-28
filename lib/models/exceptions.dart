/// Base class for all API exceptions.
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  final String message;
  final int? statusCode;
  final dynamic data;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thrown when a network error occurs (no connectivity, DNS failure, etc.).
class NetworkException implements Exception {
  NetworkException({this.message = 'Network error occurred'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when the user is not authenticated or the token is invalid/expired.
class UnauthorizedException implements Exception {
  UnauthorizedException({this.message = 'User is not authorized'});

  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Thrown when a requested resource is not found (404).
class NotFoundException implements Exception {
  NotFoundException({this.message = 'Resource not found'});

  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}

/// Thrown when a server error occurs (5xx).
class ServerException implements Exception {
  ServerException({this.message = 'Server error occurred', this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}
