import 'package:flutter_princess/data/dto/user_dto.dart';

abstract interface class AuthDataSource {
  Future<UserDto> emailLogin(String email, String password);
  Future<UserDto> googleLogin();
}
