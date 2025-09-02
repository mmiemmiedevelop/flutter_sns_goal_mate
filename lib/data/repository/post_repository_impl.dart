import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_data_source.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _dataSource;

  DocumentSnapshot? _lastDocument; // 무한 스크롤을 위해서, 어디까지 작업했는지 확인

  PostRepositoryImpl(this._dataSource);

  @override
  Future<void> deletePost(String postId) async {
    return _dataSource.deletePost(postId);
  }

  @override
  Future<List<Post>> fetchPosts() async {
    // 마지막으로 본거 다음부터 가져오기
    final snapshot = await _dataSource.fetchPosts(lastDocument: _lastDocument);

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    // 가져온 snapshot(데이터 묶음)을 entity로 변환
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Post.fromFirestore(data, doc.id);
    }).toList();
  }

  @override
  Future<void> toggleLike(String postId, String userId) async {
    return _dataSource.toggleLike(postId, userId);
  }
}
