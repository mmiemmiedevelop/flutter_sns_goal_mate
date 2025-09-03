import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'splash_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // 애니메이션 tween들
  late Animation<double> _targetGrowAnimation;
  late Animation<double> _arrowFlyAnimation;
  late Animation<double> _arrowRotationAnimation;
  late Animation<double> _arrowWobbleAnimation;
  late Animation<double> _logoAndShrinkAnimation;
  late Animation<double> _logoTextFadeAnimation;

  // 디자인 값들
  final double _finalLogoFontSize = 50.0;
  final Color _backgroundColor = const Color(0xFF613EEA);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    /// viewmodel 통신 방식을 타이머가 아닌, 애니메이션 종료 시점에 맞추기
    // 1. 애니메이션 컨트롤러 - 상태 변화 감지기 추가
    _controller.addStatusListener((status) {
      // 2. 만약 애니메이션의 상태가 'completed'(완료)가 되면,
      if (status == AnimationStatus.completed) {
        // 3. ViewModel 애니메이션 끝났다는 신호 보내기!
        ref.read(splashViewModelProvider.notifier).onAnimationEnd();
      }
    });

    // 애니메이션 시간표(Interval) 조정
    _targetGrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      //과녁이 커짐
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );
    _arrowFlyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      // 화살이 날아옴
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.25, curve: Curves.easeOut),
      ),
    );
    _arrowRotationAnimation =
        Tween<double>(begin: 3 * math.pi / 6, end: 3 * math.pi / 4)
        //화살이 돌아감
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.20, 0.23, curve: Curves.easeOut),
          ),
        );

    // 꽂히고 반동으로 꼬리 흔들리는 효과
    _arrowWobbleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: 3 * math.pi / 4, end: 3.2 * math.pi / 4),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 3.2 * math.pi / 4, end: 2.8 * math.pi / 4),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 2.8 * math.pi / 4, end: 3 * math.pi / 4),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.24, 0.30, curve: Curves.easeInOut),
          ),
        );

    _logoAndShrinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      // 과녁이 줄어듬 ('o'가 있는 위치로 과녁 이동)
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.75, curve: Curves.easeInOut),
      ),
    );
    _logoTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      // 전체 로고 이미지 페이드인에 사용
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashViewModelProvider, (previousState, newState) {
      // 뒤로가기 방지: viewmodel의 상태가 true가 되면, 현재 스플래시 화면 기록을 없애고 홈화면으로 이동
      if (newState == true) {
        context.pushReplacement('/login');
      }
    });

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // --- 1. 과녁의 '현재 크기' 계산 ---
          final double maxTargetSize = screenSize.width * 0.6;
          final double targetSize =
              (_targetGrowAnimation.value * maxTargetSize) -
              (_logoAndShrinkAnimation.value *
                  (maxTargetSize - _finalLogoFontSize));

          // --- 2. 과녁의 '현재 위치' 계산 ---
          // 'o' 텍스트가 있던 위치를 기준으로 과녁의 최종 위치 계산.
          final double finalLogoImageWidth = screenSize.width; // 전체 로고 이미지의 너비
          final double oRelativeX = finalLogoImageWidth * 0.325;

          // // 최종 위치 미세 조정을 위한 오프셋 값
          // const double finalPositionOffsetX = -15.0; // 음수 값은 '왼쪽'으로 이동
          // const double finalPositionOffsetY = -10.0; // 음수 값은 '위쪽'으로 이동

          final initialTargetPosition = Offset(
            screenSize.width / 2,
            screenSize.height / 2,
          );
          final finalTargetPosition = Offset(
            screenSize.width / 2 - (finalLogoImageWidth / 1.9) + oRelativeX,
            screenSize.height / 2 - (oRelativeX * 0.1),
          );

          final currentTargetPosition = Offset.lerp(
            initialTargetPosition,
            finalTargetPosition,
            _logoAndShrinkAnimation.value,
          )!;

          // --- 3. 화살의 '현재 위치' 및 '각도' 계산 ---
          final Offset arrowPosition;
          if (_logoAndShrinkAnimation.value == 0) {
            final path = Path();
            final startPoint = Offset(screenSize.width + 50, -50);
            final controlPoint = Offset(
              screenSize.width * 0.8,
              screenSize.height * 0.4,
            );
            final endPoint = currentTargetPosition;
            path.moveTo(startPoint.dx, startPoint.dy);
            path.quadraticBezierTo(
              controlPoint.dx,
              controlPoint.dy,
              endPoint.dx,
              endPoint.dy,
            );
            final metrics = path.computeMetrics().first;
            final distance = metrics.length * _arrowFlyAnimation.value;
            arrowPosition = metrics.getTangentForOffset(distance)!.position;
          } else {
            // 과녁이 움직이기 시작하면 화살도 과녁의 중심점을 따라가도록
            arrowPosition = currentTargetPosition;
          }

          // --- 4. 화살의 '현재 크기'와 '위치 오프셋' 동적 계산 ---
          final double initialArrowSize = 150.0;
          // 최종 화살 크기는 최종 과녁 크기('o')에 비례하도록 설정
          final double finalArrowSize = _finalLogoFontSize;
          // lerp (선형 보간)를 사용해 현재 화살 크기를 계산
          final double currentArrowSize =
              lerpDouble(
                initialArrowSize,
                finalArrowSize,
                _logoAndShrinkAnimation.value,
              ) ??
              initialArrowSize;

          final currentBaseAngle = _arrowFlyAnimation.value < 1.0
              ? _arrowRotationAnimation.value
              : _arrowWobbleAnimation.value;
          final totalAngle = currentBaseAngle + math.pi;

          // 화살 크기 축소에 맞춰 오프셋도 동적으로 조정
          final scale =
              currentArrowSize / initialArrowSize; // 1.0에서 시작하여 점점 작아지는 비율
          final radius = -65.0 * scale; // 회전 반경도 스케일에 맞춰 조정
          // 오프셋의 기준값(50, 40)도 스케일에 맞춰 조정하여 화살촉이 항상 중앙을 향하도록 함
          final offsetX = radius * math.cos(totalAngle) + (85 * scale);
          final offsetY = radius * math.sin(totalAngle) + (65 * scale);

          return Stack(
            alignment: Alignment.center,
            children: [
              // --- 5. 움직이는 과녁과 화살 (하나의 그룹) ---
              Opacity(
                opacity: 1.0 - _logoTextFadeAnimation.value,
                child: Stack(
                  children: [
                    // 과녁: 계산된 'currentTargetPosition'과 'targetSize'를 따라감
                    Positioned(
                      left: currentTargetPosition.dx - (targetSize / 2),
                      top: currentTargetPosition.dy - (targetSize / 2),
                      child: CustomPaint(
                        size: Size(targetSize, targetSize),
                        painter: TargetPainter(
                          backgroundColor: _backgroundColor,
                        ),
                      ),
                    ),
                    // 화살: 계산된 'arrowPosition', 'currentArrowSize' 등을 따라가도록
                    if (_arrowFlyAnimation.value > 0)
                      Positioned(
                        left: arrowPosition.dx - offsetX,
                        top: arrowPosition.dy - offsetY,
                        child: Transform.rotate(
                          angle: totalAngle,
                          child: SizedBox(
                            // 고정값 대신 동적으로 계산된 currentArrowSize 사용
                            width: currentArrowSize,
                            height: currentArrowSize,
                            child: Image.asset(
                              'assets/img/arrow_white_shadow.png',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // --- 6. 최종 로고 전체 이미지 ---
              Center(
                child: Opacity(
                  opacity: _logoTextFadeAnimation.value,
                  child: SizedBox(
                    width: finalLogoImageWidth,
                    child: Image.asset(
                      'assets/img/goal_mate_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// TargetPainter는 과녁 모양을 그리는 역할만!!
class TargetPainter extends CustomPainter {
  final Color backgroundColor;
  TargetPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paintWhite = Paint()..color = Colors.white;
    final paintBackground = Paint()..color = backgroundColor;
    final paintWhiteStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;

    canvas.drawCircle(center, radius, paintWhite);
    canvas.drawCircle(center, radius * 0.9, paintBackground);
    canvas.drawCircle(center, radius * 0.7, paintWhiteStroke);
    canvas.drawCircle(center, radius * 0.4, paintWhite);
    canvas.drawCircle(center, radius * 0.1, paintBackground);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
