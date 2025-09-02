//signup

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String? uid;
  final String? email;
  final String? password;
  final String? userNickName;
  bool isSignin;

  UserState({
    this.uid,
    this.email,
    this.password,
    this.userNickName,
    this.isSignin = false,
  });
}

class UserViewModel extends Notifier<UserState> {
  @override
  UserState build() {
    // TODO: implement build
    return UserState(isSignin: true);
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String imgUrl,
    required String userNickName,
  }) async {
    try {
      //회원가입
      //print('$email,$password');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      print("JOIN 완료");
      final ref = await FirebaseFirestore.instance.collection('user').add({
        'uid': userUid,
        'email': email,
        'userNickName': userNickName,
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

      //userCredential database에서 user uid찾고 있으면 true, 뷰모델상태도 true로 리턴
      //print('login : ${userCredential?.user?.uid}');
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

final userStateViewmodelProvider = NotifierProvider<UserViewModel, UserState>(
  () => UserViewModel(),
);
