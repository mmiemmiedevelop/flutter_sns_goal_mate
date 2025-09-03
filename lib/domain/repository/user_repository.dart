import 'package:flutter_princess/domain/entity/user.dart';

abstract interface class UserRepository {
  //유저불러오기
  Future<User?> fetchUser(String uid);
  //회원가입
  Future<User?> emailSignup(
    String email,
    String password,
    String imgUrl,
    String userNickname,
  );
  //프로필수정,프로필등록
  Future<User> editProfile(
    String uid, {
    String? profileImgUrl,
    String? newUserNickname,
  });
}
