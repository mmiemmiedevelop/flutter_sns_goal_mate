import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/auth_repository.dart';

abstract interface class GoogleLoginUsecase {
  Future<User?> execute();
}

class GoogleLoginUsecaseImpl implements GoogleLoginUsecase {
  final AuthRepository repository;

  GoogleLoginUsecaseImpl(this.repository);

  @override
  Future<User?> execute() async {
    return await repository.googleLogin();
  }
}
