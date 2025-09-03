import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/auth_data_source.dart';
import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);
  @override
  Future<User?> emailLogin(String email, String password) async {
    final source = await authDataSource.emailLogin(email, password);

    return User(
      uid: source.uid,
      email: source.email,
      userNickname: source.userNickname,
      profileImgUrl: source.profileImgUrl,
    );
  }
}
