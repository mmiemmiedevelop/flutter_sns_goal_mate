import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_princess/data/data_source/user_data_source.dart';
import 'package:flutter_princess/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  final _db = FirebaseFirestore.instance;
  @override
  Future<UserDto> fetchUser(String uid) async {
    //
    final snapshot = await _db
        .collection('user')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw StateError('user not found: $uid');
    }

    // final List<UserDto> getUser = snapshot.docs.map((doc) {
    //   final data = doc.data() as Map<String, dynamic>;
    //   return UserDto(
    //     uid: data['uid'] as String,
    //     email: data['email'] as String,
    //     userNickname: data['userNickname'] as String,
    //     profileImgUrl: data['profileImgUrl'] as String,
    //   );
    // }).toList();

    return UserDto.fromFirestore(snapshot.docs.first);

    // if (getUser.isEmpty) {
    //   return null;
    // }
  }

  @override
  Future<UserDto> emailSignup(
    String email,
    String password,
    String imgUrl,
    String userNickname,
  ) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('uid is null after signup');

    // final userDto = UserDto(
    //   uid: uid,
    //   email: email,
    //   userNickname: userNickname,
    //   profileImgUrl: imgUrl,
    // );

    final ref = await FirebaseFirestore.instance.collection('user').add({
      'uid': uid,
      'email': email,
      'userNickname': userNickname,
      'profileImgUrl': imgUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final snap = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    return UserDto.fromFirestore(snap.docs.first);
  }
}
