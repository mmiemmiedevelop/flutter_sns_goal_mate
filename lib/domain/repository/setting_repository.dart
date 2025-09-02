// lib/setting/setting_repository.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingRepository {
  final String userId;

  SettingRepository({required this.userId});

  // 현재 프로필 URL 가져오기
  Future<String?> getCurrentProfileUrl() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return doc.data()?['profileUrl'];
  }

  // 갤러리/Storage 업로드 후 URL 가져오기
  Future<String?> uploadProfile(File file) async {
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
    final ref = FirebaseStorage.instance.ref().child('users/$userId/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // 기존 Storage 이미지 목록
  Future<List<String>> listProfileImages() async {
    final ref = FirebaseStorage.instance.ref().child('users/$userId');
    final result = await ref.listAll();
    return Future.wait(result.items.map((e) => e.getDownloadURL()));
  }

  // Firestore 업데이트
  Future<void> updateProfileUrl(String url) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileUrl': url,
    });
  }

  // 기존 이미지 삭제
  Future<void> deleteProfileUrl(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {}
  }
}
