import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/domain/entity/post.dart';

class WriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 이미지 업로드
  Future<String> uploadImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('posts/$fileName.jpg');

    final uploadTask = await ref.putFile(image);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  // 게시글 업로드
  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toJson());
  }
}
