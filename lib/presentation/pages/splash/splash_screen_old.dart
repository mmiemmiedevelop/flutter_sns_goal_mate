// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter_princess/presentation/pages/splash/splash_viewmodel.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   // 애니메이션 tween들
//   late Animation<double> _targetGrowAnimation;
//   late Animation<double> _arrowFlyAnimation;
//   late Animation<double> _targetShrinkAnimation;
//   late Animation<double> _logoAndTextFadeAnimation;

//   final double _finalLogoFontSize = 50;
//   final Color _textColor = Colors.white;
//   final Color _backgroundColor = const Color(0xFF613EEA);

//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2), // 일단 총 애니메이션 시간: 2초
//     );

//     // 각 애니메이션들 시간대를 설정해야함(시퀀스 주는거)
//     _targetGrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       // 과녘이 커짐
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.0, 0.25, curve: Curves.easeOut),
//       ),
//     );

//     _arrowFlyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       // 화살이 날라옴
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.25, 0.40, curve: Curves.easeOut),
//       ),
//     );

//     _targetShrinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       // 과녘이 줄어듬
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.50, 0.75, curve: Curves.easeInOut),
//       ),
//     );

//     _logoAndTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       // 텍스트 나오기
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.70, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     ref.read(splashViewModelProvider.notifier).initializeApp();

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(splashViewModelProvider, (previousState, newState) {
//       // 뒤로가기 방지: viewmodel의 상태가 true가 되면, 현재 스플래시 화면 기록을 없애고 홈화면으로 이동
//       if (newState) context.pushReplacement('/home');
//     });

//     final Size screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: _backgroundColor,

//       body: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           // 정가운데에서 시작
//           final Offset startPosition = Offset(
//             screenSize.width / 2,
//             screenSize.height / 2,
//           );

//           // 로고('GoalMate')의 'O'위치로 이동
//           final Offset endPosition = Offset(
//             screenSize.width / 2 - (_finalLogoFontSize * 1.25),
//             screenSize.height / 2,
//           );

//           // 타겟 크기가 줄어들면서 포지션 바뀜
//           final Offset currentPosition = Offset.lerp(
//             startPosition,
//             endPosition,
//             _targetShrinkAnimation.value,
//           )!;

//           final double maxTargetSize = screenSize.width * 0.6;
//           final double targetSize =
//               (_targetGrowAnimation.value * maxTargetSize) -
//               (_targetShrinkAnimation.value *
//                   (maxTargetSize - _finalLogoFontSize));

//           return Stack(
//             children: [
//               if (_arrowFlyAnimation.value > 0 &&
//                   _targetShrinkAnimation.value == 0)
//                 // 화살 날라올때 포지션
//                 Positioned(
//                   left: screenSize.width * 0.2 * (1 - _arrowFlyAnimation.value),
//                   top: screenSize.height * 0.2 * (1 - _arrowFlyAnimation.value),
//                   child: Transform.rotate(
//                     angle: -math.pi / 4,
//                     child: Opacity(
//                       opacity: 1.0 - _arrowFlyAnimation.value,
//                       child: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                         size: 60,
//                       ),
//                     ),
//                   ),
//                 ),

//               // 로고랑 텍스트 나타날때 텍스트
//               Positioned(
//                 left: currentPosition.dx - (targetSize / 2),
//                 top: currentPosition.dy - (targetSize / 2),
//                 child: Opacity(
//                   opacity: 1.0 - _logoAndTextFadeAnimation.value,
//                   child: CustomPaint(
//                     size: Size(targetSize, targetSize),
//                     painter: TargetPainter(),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Opacity(
//                   opacity: _logoAndTextFadeAnimation.value,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'G',
//                             style: TextStyle(
//                               color: _textColor,
//                               fontSize: _finalLogoFontSize,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           CustomPaint(
//                             size: Size(_finalLogoFontSize, _finalLogoFontSize),

//                             painter: TargetPainter(),
//                           ),
//                           Text(
//                             'alMate',
//                             style: TextStyle(
//                               color: _textColor,
//                               fontSize: _finalLogoFontSize,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         '당신의 목표가 달성되는 순간',
//                         style: TextStyle(color: _textColor, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// /// TargetPainter는 과녁 모양을 그리는 역할만!!
// class TargetPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//     final paintWhite = Paint()..color = Colors.white;
//     canvas.drawCircle(center, radius, paintWhite);
//     final paintRed = Paint()..color = Colors.red;
//     canvas.drawCircle(center, radius * 0.8, paintRed);
//     canvas.drawCircle(center, radius * 0.6, paintWhite);
//     canvas.drawCircle(center, radius * 0.3, paintRed);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
