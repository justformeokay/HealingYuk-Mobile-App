import '../../domain/entities/auth_token_entity.dart';
import 'user_model.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthTokenModel(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      tokenType: data['token_type'] as String? ?? 'Bearer',
      expiresIn: data['expires_in'] as int? ?? 900,
    );
  }
}
