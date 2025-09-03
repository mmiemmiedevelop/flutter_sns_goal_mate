import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, bool>((
  ref,
) {
  return SplashViewModel();
});

class SplashViewModel extends StateNotifier<bool> {
  // 생성될때, 초기 상태는 false(준비가 안되었다)
  SplashViewModel() : super(false);

  // Future<void> initializeApp() async {
  //   await Future.delayed(const Duration(milliseconds: 3500));

  void onAnimationEnd() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) state = true;
  }
}
