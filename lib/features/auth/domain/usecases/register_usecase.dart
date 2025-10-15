import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
@injectable
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute registration
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Validate input
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return Left(ValidationFailure(message: emailValidation));
    }

    final passwordValidation = Validators.validatePassword(params.password);
    if (passwordValidation != null) {
      return Left(ValidationFailure(message: passwordValidation));
    }

    final nameValidation = Validators.validateRequired(params.name, 'Name');
    if (nameValidation != null) {
      return Left(ValidationFailure(message: nameValidation));
    }

    return await _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Parameters for register use case
class RegisterParams extends Equatable {
  const RegisterParams({
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
