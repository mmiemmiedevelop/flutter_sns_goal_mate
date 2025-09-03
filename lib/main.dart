import 'package:flutter/material.dart';
import 'package:flutter_princess/config/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_princess/presentation/common_widget/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart'; // flutterfire configure 로 생성된 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // go_router
      theme: GoalMateTheme.lightTheme,
      title: 'GoalMate',
      debugShowCheckedModeBanner: false,
    );
  }
}
