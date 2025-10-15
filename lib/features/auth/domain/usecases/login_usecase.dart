import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
@injectable
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute login
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validate input
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return Left(ValidationFailure(message: emailValidation));
    }

    final passwordValidation = Validators.validateRequired(params.password, 'Password');
    if (passwordValidation != null) {
      return Left(ValidationFailure(message: passwordValidation));
    }

    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
