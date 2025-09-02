import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_princess/data/data_source/auth_data_source.dart';
import 'package:flutter_princess/data/data_source/user_data_source.dart';
import 'package:flutter_princess/data/dto/user_dto.dart';

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<UserDto> emailLogin(String email, String password) async {
    //firebase Auth Login
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user == null) throw StateError('user is null after Login');
    final uid = user.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) throw StateError('user not found : $uid');

    return UserDto.fromFirestore(snapshot.docs.first);
  }
}
