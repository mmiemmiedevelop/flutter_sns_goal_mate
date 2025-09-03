import 'package:flutter_princess/data/dto/user_dto.dart';

//회원가입
//유저정보를 불러와야함
abstract interface class UserDataSource {
  //유저정보 불러오기
  //유저정보가 없을수도 있음
  Future<UserDto?> fetchUser(String uid);
  //회원가입
  Future<UserDto?> emailSignup(
    String password,
    String email,
    String imgUrl,
    String userNickname,
  );
  //유저데이터수정
  Future<UserDto> editProfile(
    String uid, {
    //전달된것만 갱신
    String? profileImgUrl,
    String? newUserNickname,
  });
}
