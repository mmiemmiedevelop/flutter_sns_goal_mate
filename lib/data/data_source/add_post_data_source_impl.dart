import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/add_post_data_source.dart';

class AddPostDataSourceImpl implements AddPostDataSource {
  final _db = FirebaseFirestore.instance;
  @override
  Future<void> addPost(
    String uid,
    List<String> tag,
    String content,
    List<String> imgurl,
    DateTime? createdAt,
  ) async {
    final snapshot = await _db
        .collection('user')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
  }
}
