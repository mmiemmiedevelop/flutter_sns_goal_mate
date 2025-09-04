import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/user_repository.dart';

class FetchUserUsecase {
  final UserRepository userRepository;
  FetchUserUsecase(this.userRepository);
  Future<User?> execute(String uid) async {
    return await userRepository.fetchUser(uid);
  }
}
