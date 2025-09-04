import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/user_data_source.dart';
import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;
  UserRepositoryImpl(this.userDataSource);

  @override
  Future<User?> fetchUser(String uid) async {
    final source = await userDataSource.fetchUser(uid);
    if (source == null) return null;
    return User(
      uid: source.uid,
      email: source.email,
      userNickname: source.userNickname,
      profileImgUrl: source.profileImgUrl,
    );
  }

  @override
  Future<User?> emailSignup(
    String email,
    String password,
    String imgUrl,
    String userNickname,
  ) async {
    final source = await userDataSource.emailSignup(
      email,
      password,
      imgUrl,
      userNickname,
    );
    if (source == null) return null;
    return User(
      uid: source.uid,
      email: source.email,
      userNickname: source.userNickname,
      profileImgUrl: source.profileImgUrl,
    );
  }
}
