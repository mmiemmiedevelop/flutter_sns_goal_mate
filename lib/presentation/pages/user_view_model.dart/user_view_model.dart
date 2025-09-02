//signup

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String? uid;
  final String? email;
  final String? profileImgUrl;
  final String? userNickname;

  UserState({this.uid, this.email, this.profileImgUrl, this.userNickname});
}

class UserViewModel extends Notifier<UserState?> {
  @override
  UserState? build() {
    return null;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String imgUrl,
    required String userNickname,
  }) async {
    try {
      //회원가입
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = FirebaseAuth.instance.currentUser?.uid;
      print("JOIN 완료");
      final ref = await FirebaseFirestore.instance.collection('user').add({
        'uid': uid,
        'email': email,
        'userNickname': userNickname,
        'profileImgUrl': imgUrl,
        'createdAt': FieldValue.serverTimestamp(), // 서버 시간
      });

      return login(email, password);
    } catch (e) {
      print(e);
    }
    return false;
  }

  //login
  //user entity를 관리하는 뷰모델을 리버팟으로 만들어서 최초는 null,로그인성공할때 user Entity fire database에서 읽어와서 provider할당 <Future<boolean>>
  Future<bool> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('login ok');
      final getUserUid = userCredential.user!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: '$getUserUid')
          .get();
      // for (final doc in snapshot.docs) {
      //   print('docId: ${doc.id}');
      //   print('uid: ${doc['uid']}');
      //   print('email: ${doc['email']}');
      //   print('nickname: ${doc['userNickname']}');
      //   print('profile: ${doc['profileImgUrl']}');
      // }
      final List<UserState> getUser = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserState(
          uid: data['uid'] as String,
          email: data['email'] as String,
          userNickname: data['userNickname'] as String,
          profileImgUrl: data['profileImgUrl'] as String,
        );
      }).toList();
      print(getUser);
      //userCredential database에서 user uid찾고 있으면 true, 뷰모델상태도 true로 리턴
      return true;
      //firestore에서 유저정보 불러오고 UserState update
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return false;
  }
}

final userStateViewmodelProvider = NotifierProvider<UserViewModel, UserState?>(
  () => UserViewModel(),
);
