import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/user_repository.dart';

class EditProfileUsecase {
  final UserRepository userRepository;
  EditProfileUsecase(this.userRepository);

  Future<User?> execute(
    String uid, {
    String? profileImgUrl,
    String? newUserNickname,
  }) async {
    return await userRepository.editProfile(
      uid,
      profileImgUrl: profileImgUrl,
      newUserNickname: newUserNickname,
    );
  }
}
