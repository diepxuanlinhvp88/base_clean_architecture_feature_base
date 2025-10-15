part of 'auth_bloc.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when user requests login
class LoginRequested extends AuthEvent {
  const LoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Event triggered when user requests registration
class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
}

/// Event triggered when user requests logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event triggered when authentication status changes
class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged({
    required this.isAuthenticated,
    this.user,
  });

  final bool isAuthenticated;
  final User? user;

  @override
  List<Object?> get props => [isAuthenticated, user];
}

/// Event triggered to check current authentication status
class AuthStatusRequested extends AuthEvent {
  const AuthStatusRequested();
}

/// Event triggered when password reset is requested
class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}
