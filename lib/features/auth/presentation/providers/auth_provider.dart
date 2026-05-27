import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/session_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUsecase _login;
  final RegisterUsecase _register;
  final LogoutUsecase _logout;
  final SessionService _session;

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _user;
  String? _errorMessage;
  Map<String, dynamic>? _fieldErrors;

  AuthProvider(this._login, this._register, this._logout, this._session);

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get fieldErrors => _fieldErrors;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> checkSession() async {
    final loggedIn = await _session.isLoggedIn();
    if (loggedIn) {
      final userData = await _session.getUser();
      if (userData != null) {
        _user = _userFromJson(userData);
      }
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading();
    final result = await _login(email: email, password: password);
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (auth) {
        _user = auth.user;
        _status = AuthStatus.authenticated;
        _errorMessage = null;
        _fieldErrors = null;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading();
    final result = await _register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (_) {
        _status = AuthStatus.unauthenticated;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    // Don't call _setLoading() here — it sets status to non-authenticated
    // which triggers GoRouter redirect before logout is complete
    final result = await _logout();
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    _fieldErrors = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _fieldErrors = null;
    notifyListeners();
  }

  void _setError(Failure failure) {
    _status = AuthStatus.error;
    _errorMessage = failure.message;
    if (failure is ValidationFailure) {
      _fieldErrors = failure.errors;
    }
    notifyListeners();
  }

  UserEntity _userFromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'user',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
