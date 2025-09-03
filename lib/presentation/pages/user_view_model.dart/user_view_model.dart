//signup

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_princess/presentation/pages/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//로그인한 user uid 가져오는법
//final userState = ref.watch(userStateViewmodelProvider);
//구독 후 userState?.uid
class UserState {
  final String uid;
  final String email;
  final String profileImgUrl;
  final String userNickname;

  UserState({
    required this.uid,
    required this.email,
    required this.profileImgUrl,
    required this.userNickname,
  });

  @override
  String toString() {
    return 'uid: $uid';
  }
}

class UserViewModel extends Notifier<UserState?> {
  @override
  UserState? build() {
    return null;
  }

  //회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String imgUrl,
    required String userNickname,
  }) async {
    final usecase = ref.read(emailSignupusecaseProvider);
    try {
      await usecase.execute(email, password, imgUrl, userNickname);
      return login(email, password);
    } catch (e) {
      print(e);
    }
    return false;
  }

  //login
  Future<bool> login(String email, String password) async {
    final usecase = ref.read(emailLoginUsecaseProvider);
    try {
      final user = await usecase.execute(email, password);
      if (user == null) return false;

      state = UserState(
        uid: user.uid,
        email: user.email,
        profileImgUrl: user.profileImgUrl ?? '',
        userNickname: user.userNickname,
      );

      return true;
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
