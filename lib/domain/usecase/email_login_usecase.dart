import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/auth_repository.dart';

class EmailLoginUsecase {
  final AuthRepository authRepository;
  EmailLoginUsecase(this.authRepository);

  Future<User?> execute(String email, String password) async {
    return await authRepository.emailLogin(email, password);
  }
}
