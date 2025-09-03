import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page.dart';
import 'package:flutter_princess/config/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_princess/presentation/pages/login/login_page.dart';
import 'package:flutter_princess/presentation/pages/setting/setting_page.dart';
import 'package:flutter_princess/presentation/pages/sign_up_page/sign_up_page.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_detail_page.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart'; // flutterfire configure 로 생성된 파일

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoalMate',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      routes: {
        '/': (context) => const HomePage(),
        '/write': (context) => const WritePage(),
      },
      // home: WritePage(),
    );
  }
}
