import 'package:flutter_princess/domain/entity/user.dart';

abstract interface class AuthRepository {
  Future<User?> emailLogin(String email, String password);
  Future<User?> googleLogin();
}
