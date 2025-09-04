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
    throw Exception('이미지 업로드 실패: $e');
  }
}

Future<String> getImgUrls({
  required File imageFile, //Flie타입 이미지
  required String path, //경로 (ex=post)
  required int index, //index
}) async {
  //경로생성1
  final name =
      '${index}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
  //fireStore에 경로
  final ref = FirebaseStorage.instance.ref('users/$path/$name');

  //이미지 전처리
  final bytes = await imageFile.readAsBytes();
  //경로에 이미지 저장
  final task = await ref.putData(bytes);
  //url반환
  return await task.ref.getDownloadURL();
}

Future<List<String>> uploadImages({
  required List<File> imageFiles, //file List
  required String path, // ex=post
}) async {
  //리스트 초기화
  final futures = <Future<String>>[];

  for (var i = 0; i < imageFiles.length; i++) {
    //리스트에 추가
    futures.add(getImgUrls(imageFile: imageFiles[i], path: path, index: i));
  }
  //Future가 끝날떄 까지 기다린후 반환
  return Future.wait(futures);
}
