import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> getImgUrl({
  required File imageFile,
  required String path,
}) async {
  try {
    // 저장 경로 지정: users/{uid}/profile.jpg
    final ref = FirebaseStorage.instance.ref('users/$path');

    // 파일을 바이트 배열로 읽기
    final imgBytes = await imageFile.readAsBytes();

    // Firebase Storage에 업로드
    final uploadTask = await ref.putData(imgBytes);

    // 업로드 완료 후 다운로드 URL 반환
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    // 예외 처리 (필요하면 로깅이나 사용자 알림 추가)
    throw Exception('이미지 업로드 실패: $e');
  }
}
//profile.jpg

Future<List<String>> getImgUrls({
  required List<File> imageFiles,
  required String path,
}) async {
  final futures = imageFiles.map(
    (file) => getImgUrl(imageFile: file, path: path),
  );
  return Future.wait(futures);
}
