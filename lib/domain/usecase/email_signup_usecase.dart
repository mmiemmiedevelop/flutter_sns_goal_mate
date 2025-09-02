import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/user_repository.dart';

class EmailSignupUsecase {
  final UserRepository userRepository;
  EmailSignupUsecase(this.userRepository);

  Future<User?> execute(
    String email,
    String password,
    String imgUrl,
    String userNickname,
  ) async {
    return await userRepository.emailSignup(
      email,
      password,
      imgUrl,
      userNickname,
    );
  }
}
