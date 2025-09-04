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
  Future<void> addPost(Post post) async {
    return _dataSource.addPost(post.id, post.toJson());
  }

  @override
  Future<List<Post>> fetchPosts() async {
    // 마지막으로 본거 다음부터 가져오기
    final snapshot = await _dataSource.fetchPosts(lastDocument: _lastDocument);

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    // 가져온 snapshot(데이터 묶음)을 entity로 변환하고 실제 댓글 수 계산
    final posts = <Post>[];
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // 실제 댓글 수를 Firebase에서 계산
      final actualCommentCount = await _dataSource.getActualCommentCount(
        doc.id,
      );

      // 데이터에 실제 댓글 수 반영
      final updatedData = Map<String, dynamic>.from(data);
      updatedData['commentCount'] = actualCommentCount;

      posts.add(Post.fromFirestore(updatedData, doc.id));
    }

    return posts;
  }

  @override
  Future<Post?> getPostById(String postId) async {
    final snapshot = await _dataSource.getPostById(postId);
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;

      // 실제 댓글 수를 Firebase에서 계산
      final actualCommentCount = await _dataSource.getActualCommentCount(
        postId,
      );

      // 데이터에 실제 댓글 수 반영
      final updatedData = Map<String, dynamic>.from(data);
      updatedData['commentCount'] = actualCommentCount;

      return Post.fromFirestore(updatedData, snapshot.id);
    }
    return null;
  }

  @override
  Future<void> toggleLike(String postId, String userId) async {
    return _dataSource.toggleLike(postId, userId);
  }

  @override
  void reset() {
    // 페이지 상태 초기화
    _lastDocument = null;
  }
}
