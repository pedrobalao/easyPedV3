import 'package:dio/dio.dart';
import 'package:easypedv3/models/exceptions.dart';
import 'package:easypedv3/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Creates and configures a [Dio] instance with interceptors for
/// authentication, retry, and logging.
Dio createApiClient({AuthenticationService? authService}) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Auth token interceptor — auto-attach Firebase token
  final auth = authService ?? AuthenticationService();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await auth.getUserToken();
          options.headers['Authorization'] = token;
        } on UserNotAuthenticated {
          // Let the request go without auth — server will return 401
        }
        handler.next(options);
      },
    ),
  );

  // Retry interceptor — retry on 5xx errors, max 2 retries
  dio.interceptors.add(_RetryInterceptor(dio: dio, maxRetries: 2));

  // Logging interceptor — debug mode only
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}

/// Maps a [DioException] to a typed domain exception.
Never throwTypedException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      throw NetworkException(message: e.message ?? 'Connection error');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw UnauthorizedException(
          message: e.response?.statusMessage ?? 'Unauthorized',
        );
      } else if (statusCode == 404) {
        throw NotFoundException(
          message: e.response?.statusMessage ?? 'Not found',
        );
      } else if (statusCode != null && statusCode >= 500) {
        throw ServerException(
          statusCode: statusCode,
          message: e.response?.statusMessage ?? 'Server error',
        );
      }
      throw ApiException(
        statusCode: statusCode,
        message: e.response?.statusMessage ?? 'Request failed',
        data: e.response?.data,
      );
    case DioExceptionType.cancel:
      throw ApiException(message: 'Request cancelled');
    case DioExceptionType.badCertificate:
      throw NetworkException(message: 'Bad certificate');
    case DioExceptionType.unknown:
      throw NetworkException(
        message: e.message ?? 'Unknown network error',
      );
  }
}

/// Interceptor that retries failed requests on 5xx status codes.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor({required this.dio, this.maxRetries = 2});

  final Dio dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
      if (retryCount < maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        if (kDebugMode) {
          debugPrint(
            'Retrying request (${retryCount + 1}/$maxRetries): '
            '${err.requestOptions.path}',
          );
        }
        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }
    return handler.next(err);
  }
}
