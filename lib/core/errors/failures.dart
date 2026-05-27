import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<Either<Failure, void>>;

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.'])
      : super(statusCode: 0);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.'])
      : super(statusCode: 401);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure(super.message, {this.errors})
      : super(statusCode: 422);

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
