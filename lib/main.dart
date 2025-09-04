import 'package:flutter/material.dart';
import 'package:flutter_princess/config/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_princess/presentation/common_widget/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// flutterfire configure 로 생성된 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://42581d6f0bfbf152113239f124e5b691@o4509936148348928.ingest.us.sentry.io/4509961160491008';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () =>
        runApp(SentryWidget(child: const ProviderScope(child: MyApp()))),
  );
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
