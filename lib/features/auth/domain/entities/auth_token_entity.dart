import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class AuthTokenEntity extends Equatable {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const AuthTokenEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
