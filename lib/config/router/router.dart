import 'dart:io';

import 'package:flutter_princess/presentation/pages/comment_page/comment_page.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page.dart';
import 'package:flutter_princess/presentation/pages/login/login_page.dart';
import 'package:flutter_princess/presentation/pages/setting/setting_page.dart';
import 'package:flutter_princess/presentation/pages/sign_up_page/sign_up_nickname_page%20.dart';
import 'package:flutter_princess/presentation/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/signup',

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(), // TODO: LoginPage UI 생성 후 연결
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
      }, // TODO: LoginPage UI 생성 후 연결
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/write',
      name: 'write',
      builder: (context, state) => WritePage(), // TODO: WritePage UI 생성 후 연결
    ),
    GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (context, state) =>
          SettingPage(), // TODO: SettingPage UI 생성 후 연결
    ),
    // GoRoute(
    //   // 게시글 ID를 파라미터로 받아 댓글 페이지로 이동
    //   path: '/comment/:postId',
    //   name: 'comment',
    //   builder: (context, state) {
    //     final postId = state.pathParameters['postId']!;
    //     return CommentPage(postId: postId); // TODO: CommentPage UI 생성 후 연결
    //   },
    // ),
  ],
);
