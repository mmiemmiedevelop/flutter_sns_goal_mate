import 'package:intl/intl.dart';

/// 숫자를 SNS 스타일(k, M)로 변환하는 함수
///
/// 예시:
/// - 1234 -> "1.2k"
/// - 1000 -> "1k"
/// - 1234567 -> "1.2M"
String formatNumber(int number) {
  if (number >= 1000000) {
    double num = number / 1000000;
    return '${num.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  } else if (number >= 1000) {
    double num = number / 1000;
    return '${num.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
  } else {
    return number.toString();
  }
}

/// 게시글 업로드 시간을 상대 시간('n분 전' 등)으로 변환하는 함수
///
///  예시:
/// - 10분 전 -> "10분 전"
/// - 2시간 전 -> "2시간 전"
/// - 하루 이상 -> "yyyy-MM-dd"
String formatTimestamp(DateTime dt) {
  final now = DateTime.now();
  final difference = now.difference(dt);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else {
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}
