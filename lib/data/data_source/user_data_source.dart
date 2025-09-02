import 'package:flutter_princess/data/dto/user_dto.dart';

//회원가입
//유저정보를 불러와야함
abstract interface class UserDataSource {
  //유저정보 불러오기
  Future<UserDto> fetchUser();
  //로그인
  Future<UserDto> emailSignin();
  //회원가입
  Future<UserDto> emainSignup();
}
