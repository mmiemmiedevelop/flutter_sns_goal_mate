import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/common_widget/util/get_img_url.dart';
import 'package:flutter_princess/presentation/pages/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

//로그인한 user uid 가져오는법
// final fecthuser = ref.read(fetchUserusecaseProvider);
// final userLog = await fecthuser.execute(user.uid);
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
    required File? imgUrl,
    required String userNickname,
  }) async {
    final usecase = ref.read(emailSignupusecaseProvider);

    try {
      final user = await usecase.execute(email, password, '', userNickname);
      if (user == null) return false;

      //이미지 -> url변환 전처리
      // final ref = FirebaseStorage.instance.ref('users/${user.uid}/profile.jpg');
      // final imgbyte = await imgUrl!.readAsBytes();
      // final putData = await ref.putData(imgbyte);
      // final String profileImgUrl = await putData.ref.getDownloadURL();
      final profileImgUrl = await getImgUrl(
        imageFile: imgUrl,
        path: '${user.uid}/profile.jpg',
      );
      editProfile(user.uid, userNickname, profileImgUrl);
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

  //edit
  Future<bool> editProfile(
    String uid,
    String? userNickname,
    String? profileImgUrl,
  ) async {
    final usecase = ref.read(editProfileUsecaseProvider);

    try {
      final user = await usecase.execute(
        uid,
        newUserNickname: userNickname,
        profileImgUrl: profileImgUrl,
      );
      state = UserState(
        uid: user!.uid,
        email: user.email,
        profileImgUrl: user.profileImgUrl ?? '',
        userNickname: user.userNickname,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  //구글로그인
  // Future<void> googleLogin() async {
  //   final GoogleSignIn googleSignIn =  GoogleSignIn(scopes: ['email']);

  //   // 구글 로그인
  //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn
  //       .signIn();

  //   // 구글 로그인 결과에서 accessToken과 idToken을 가져오기 위해
  //   // GoogleSignInAuthentication 가져오기
  //   final GoogleSignInAuthentication? googleSignInAuthentication =
  //       await googleSignInAccount?.authentication;

  //   if (googleSignInAuthentication == null) {
  //     return;
  //   }

  //   // Firebase Auth 에서 accessToken과 idToken으로 로그인 하기 위해 OAuthCredential 생성
  //   final OAuthCredential oauthCred = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //   final UserCredential userCredential = await FirebaseAuth.instance
  //       .signInWithCredential(oauthCred);
  //   print('uid : ${userCredential.user?.uid}');
  // }

  // Future<void> googleLogin() async {
  //   구글인증 -> 계정정보 반환
  //   await GoogleSignIn.instance.initialize(
  //     serverClientId:
  //         '206708911603-vtljdc115rrfetv8cdp7o7i65vc461cn.apps.googleusercontent.com',
  //   );
  //   final account = await GoogleSignIn.instance.authenticate();
  //   //인증결과에서 id토큰추출
  //   final idToken = account.authentication.idToken!;
  //   //firebase에 토큰전달
  //   final cred = GoogleAuthProvider.credential(idToken: idToken);
  //   //사용자세션생성
  //   final uc = await FirebaseAuth.instance.signInWithCredential(cred);
  //   debugPrint('email=${account.email}, uid=${uc.user?.uid}');
  // }
}

final userStateViewmodelProvider = NotifierProvider<UserViewModel, UserState?>(
  () => UserViewModel(),
);
