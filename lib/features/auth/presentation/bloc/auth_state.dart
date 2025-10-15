part of 'auth_bloc.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required this.user,
  });

  final User user;

  @override
  List<Object> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication fails
class AuthError extends AuthState {
  const AuthError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

/// State when password reset email is sent successfully
class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

/// State when user profile is updated
class ProfileUpdated extends AuthState {
  const ProfileUpdated({
    required this.user,
  });

  final User user;

  @override
  List<Object> get props => [user];
}
