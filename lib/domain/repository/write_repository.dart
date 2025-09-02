import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class WriteRepository {
  Future<String?> uploadImage(File image) async {
    final fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.png';
    final ref = FirebaseStorage.instance.ref().child(fileName);
    try {
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('이미지 업로드 실패: $e');
      return null;
    }
  }
}
