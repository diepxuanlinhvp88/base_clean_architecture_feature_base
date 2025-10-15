import 'package:equatable/equatable.dart';

/// User entity - represents a user in the domain layer
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phone,
        isEmailVerified,
        createdAt,
        updatedAt,
      ];

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
