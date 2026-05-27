import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<AuthTokenEntity> login({
    required String email,
    required String password,
  });

  ResultFuture<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  ResultFuture<void> logout();

  ResultFuture<void> logoutAll();

  ResultFuture<void> forgotPassword({required String email});
}

// ResultFuture is defined in core/errors/failures.dart
