import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/session_service.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SessionService _session;

  const AuthRepositoryImpl(this._remote, this._session);

  @override
  ResultFuture<AuthTokenEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remote.login(email: email, password: password);
      await Future.wait([
        _session.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        ),
        _session.saveUser((result.user as UserModel).toJson()),
      ]);
      return Right(result);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await _remote.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(result);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await _remote.logout();
      await _session.clearSession();
      return const Right(null);
    } on AppException {
      // Clear session regardless of API error
      await _session.clearSession();
      return const Right(null);
    }
  }

  @override
  ResultFuture<void> logoutAll() async {
    try {
      await _session.clearSession();
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _remote.forgotPassword(email: email);
      return const Right(null);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on AppException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
