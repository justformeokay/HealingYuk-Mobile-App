import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? avatarUrl;
  final bool emailVerified;
  final bool isActive;
  final String createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatarUrl,
    required this.emailVerified,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email];

  bool get isAdmin => role == 'admin';
  bool get isOrganizer => role == 'organizer';
}
