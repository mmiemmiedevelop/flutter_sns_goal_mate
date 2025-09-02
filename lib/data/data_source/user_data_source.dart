import 'package:flutter_princess/data/dto/user_dto.dart';

//회원가입
//유저정보를 불러와야함
abstract interface class UserDataSource {
  //프로필 불러오기
  Future<UserDto> getUser(uid);
  //로그인
  Future<UserDto> authUser(uid);
  //회원가입
  Future<UserDto> signUpUser(uid);
}
