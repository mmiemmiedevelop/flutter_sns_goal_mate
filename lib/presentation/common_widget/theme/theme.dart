import 'package:flutter/material.dart';

// GoalMate 앱의 전체적인 디자인 테마를 정의하는 클래스입니다.
class GoalMateTheme {
  // --- 1. 색상 정의 (Color Palette) ---
  static const Color signatureColor = Color(0xFF613EEA); // 앱의 시그니처 색상 (보라색)
  static const Color black = Colors.black; // 기본 텍스트 및 아이콘 색상
  static const Color white = Colors.white; // 기본 배경 및 버튼 텍스트 색상

  /// --- 2. 앱의 라이트(Light) 테마 데이터 ---
  static ThemeData get lightTheme {
    return ThemeData(
      // --- 2-1. 기본 설정 ---
      brightness: Brightness.light,
      fontFamily: 'NotoSansKR', // 앱 전체의 기본 글꼴
      scaffoldBackgroundColor: white, // 모든 화면의 기본 배경색은 '흰색'
      // splashColor와 highlightColor를 투명하게 만들어, 버튼 등에서 불필요한 물결 효과를 제거합니다.
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      // --- 2-2. 색상표(ColorScheme) 재구성 ---
      colorScheme: const ColorScheme.light(
        primary: signatureColor,
        onPrimary: white,
        secondary: signatureColor,
        onSecondary: white,
        surface: white,
        onSurface: black,
        error: Color(0xFFD32F2F), // 에러시 빨간색
        onError: white,
      ),

      // --- 2-3. 텍스트 테마(TextTheme)---
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: black,
          inherit: true,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: black,
          inherit: true,
        ),
        bodyLarge: TextStyle(fontSize: 16.0, color: black, inherit: true),
        bodyMedium: TextStyle(fontSize: 14.0, color: black, inherit: true),
        labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: white,
          inherit: true,
        ),
      ),

      // --- 2-4. 개별 위젯 테마 재설정 ---

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: black,
          fontFamily: 'NotoSansKR',
          inherit: false,
        ),
      ),

      // ElevatedButton (입체감 있는 버튼) 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: signatureColor, // 버튼 배경은 시그니처 색상
          foregroundColor: white, // 버튼 위 글씨는 흰색
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansKR',
            inherit: true,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0, // 그림자 제거하여 플랫한 디자인으로 변경
        ),
      ),

      // TextField 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100], // 입력창 배경: 반투명 회색???
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        // 기본 테두리
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.black12, width: 1.5),
        ),
        // 입력창을 터치했을 때 테두리를 시그니처 색상으로 강조
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: signatureColor, width: 2.0),
        ),
      ),
    );
  }
}
