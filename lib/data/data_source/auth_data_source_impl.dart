import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_princess/data/data_source/auth_data_source.dart';
import 'package:flutter_princess/data/dto/user_dto.dart';
import 'package:flutter/services.dart';

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<UserDto> emailLogin(String email, String password) async {
    // Firebase Auth 이메일 로그인
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('login ok');

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

  @override
  Future<UserDto> googleLogin() async {
    try {
      // Google Sign-In 인스턴스 설정 (serverClientId 추가)
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '206708911603-podalv6hbqs6b1695gp34c38r6c6tnu8.apps.googleusercontent.com',
      );

      // Google Sign-In 진행
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        // 사용자가 로그인을 취소한 경우 - 예외를 던지지 않고 null 반환하거나 특별한 처리
        return Future.error('CANCELLED');
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 인증 자격증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      // Firebase로 로그인
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw StateError('Firebase user is null after Google login');
      }

      final uid = firebaseUser.uid;

      // Firestore에서 사용자 정보 조회
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      // 기존 사용자가 없으면 새로 생성
      if (snapshot.docs.isEmpty) {
        final newUserData = {
          'uid': uid,
          'email': firebaseUser.email ?? '',
          'userNickname': firebaseUser.displayName ?? 'Google 사용자',
          'profileImgUrl': firebaseUser.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .set(newUserData);

        return UserDto(
          uid: uid,
          email: firebaseUser.email ?? '',
          userNickname: firebaseUser.displayName ?? 'Google 사용자',
          profileImgUrl: firebaseUser.photoURL ?? '',
        );
      } else {
        return UserDto.fromFirestore(snapshot.docs.first);
      }
    } on PlatformException catch (e) {
      // Google Sign-In 관련 플랫폼 예외 처리
      if (e.code == 'sign_in_canceled') {
        throw Exception('사용자가 로그인을 취소했습니다.');
      } else if (e.code == 'network_error') {
        throw Exception('네트워크 연결을 확인해주세요.');
      } else {
        throw Exception('Google 로그인 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('Google 로그인 실패: $e');
    }
  }
}
