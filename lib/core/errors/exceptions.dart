import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.'])
      : super(statusCode: 0);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out.'])
      : super(statusCode: 408);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Access denied.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.'])
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(super.message, {this.errors})
      : super(statusCode: 422);

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error. Please try again.'])
      : super(statusCode: 500);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local storage error.']);
}

class UnexpectedException extends AppException {
  const UnexpectedException([super.message = 'An unexpected error occurred.']);
}
