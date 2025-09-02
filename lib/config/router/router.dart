import 'package:flutter/material.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_page.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page.dart';
import 'package:flutter_princess/presentation/pages/login/login_page.dart';
import 'package:flutter_princess/presentation/pages/setting/setting_page.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  // initialLocation: '/login',
  initialLocation: '/home',

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginPage(),
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
      builder: (context, state) => SettingPage(),
    ),
    GoRoute(
      path: '/comment/:postId',
      name: 'comment',
      builder: (context, state) {
        final post = state.extra as Post?;
        if (post == null) {
          return const Scaffold(body: Center(child: Text("오류: 게시물 정보가 없습니다.")));
        }
        // TODO: 나중에 provider에서 직접 가져오기 (firebase auth)
        return CommentPage(
          postId: post.id,
          userId: post.userId, // (임시) 나중에는 실제 로그인 유저 정보로 변경
          userNickname: post.userNickname,
          userProfileImageUrl: post.userProfileImageUrl,
        );
      },
    ),
  ],
);
