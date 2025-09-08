import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_page.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page.dart';
import 'package:flutter_princess/presentation/pages/login/login_page.dart';
import 'package:flutter_princess/presentation/pages/setting/setting_page.dart';
import 'package:flutter_princess/presentation/pages/sign_up_page/sign_up_nick_name_page%20.dart';
import 'package:flutter_princess/presentation/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter_princess/presentation/pages/splash/splash_screen.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_page.dart';
import 'package:flutter_princess/presentation/pages/user_view_model/user_view_model.dart';
import 'package:flutter_princess/presentation/policy/signup_agreement.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',

  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/policy',
      name: 'policy',
      builder: (context, state) => SignupAgreement(
        onAgreed: () {
          return context.go('/signup');
        },
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => SignUpPage(), // TODO: LoginPage UI 생성 후 연결
    ),
    GoRoute(
      path: '/signupnickname',
      name: 'signupnickname',
      builder: (context, state) {
        final map = (state.extra as Map<String, dynamic>?) ?? {};
        final email = map['email'] as String? ?? '';
        final password = map['password'] as String? ?? '';
        final imageFile = map['imageFile'] as File?;
        return SignUpNickNamePage(
          email: email,
          password: password,
          imageFile: imageFile,
        );
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/write',
      name: 'write',
      builder: (context, state) => WritePage(),
    ),
    GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (context, state) {
        final userState = state.extra as UserState?;
        if (userState == null) {
          return const Scaffold(body: Center(child: Text("오류: 사용자 정보가 없습니다.")));
        }
        // UserState를 User로 변환해서 SettingPage에 전달
        final user = User(
          uid: userState.uid,
          email: userState.email,
          profileImgUrl: userState.profileImgUrl,
          userNickname: userState.userNickname,
        );
        return SettingPage(user: user);
      },
    ),
    GoRoute(
      path: '/comment/:postId',
      name: 'comment',
      builder: (context, state) {
        final post = state.extra as Post?;
        if (post == null) {
          return const Scaffold(body: Center(child: Text("오류: 게시물 정보가 없습니다.")));
        }

        return CommentPage(postId: post.id, postUserId: post.userId);
      },
    ),
  ],
);
