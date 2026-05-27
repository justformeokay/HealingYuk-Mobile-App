import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> logout();

  Future<void> forgotPassword({required String email});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _api;

  const AuthRemoteDatasourceImpl(this._api);

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthTokenModel.fromJson(response);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return UserModel.fromJson(
        (response['data'] as Map<String, dynamic>)['user']
            as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _api.post('/auth/logout');
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _api.post('/auth/forgot-password', data: {'email': email});
  }
}
