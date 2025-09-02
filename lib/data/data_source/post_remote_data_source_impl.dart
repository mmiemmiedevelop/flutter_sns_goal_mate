import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_data_source.dart';

class PostRemoteDataSourceImpl implements PostDataSource {
  final FirebaseFirestore _firestore;
  late final CollectionReference _postsCollection = _firestore.collection(
    'post',
  );

  PostRemoteDataSourceImpl(this._firestore);

  // Firestore에서 게시물 목록 가져오기
  @override
  Future<QuerySnapshot<Object?>> fetchPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    // 쿼리 시작 - 생성 시간 역순으로 정렬
    Query query = _postsCollection
        .orderBy('createdAt', descending: true)
        .limit(5); // 한 번에 5개씩만 가져오기

    // 무한 스크롤
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }

  @override
  Future<void> toggleLike(String postId, String userId) async {
    // 여기서 Firestore Transaction을 사용하여 'likedBy'와 'likeCount'를 업데이트함
    final postRef = _postsCollection.doc(postId);
    // Transaction: 데이터를 수정하는 동안 아무도 방해하지 못하도록 선언하는거라고 함
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      final List<dynamic> likedBy = snapshot.get('likedBy') ?? [];

      if (likedBy.contains(userId)) {
        // 이미 누른 경우 (좋아요 취소)
        transaction.update(postRef, {
          'likedBy': FieldValue.arrayRemove([userId]),
          'likeCount': FieldValue.increment(-1),
        });
      } else {
        // 아직 누르지 않은 경우 (좋아요)
        transaction.update(postRef, {
          'likedBy': FieldValue.arrayUnion([userId]),
          'likeCount': FieldValue.increment(1),
        });
      }
    });
  }

  @override
  Future<void> deletePost(String postId) async {
    // 여기에서는 'posts' 컬렉션에서 해당 문서를 삭제함
    return _postsCollection.doc(postId).delete();
  }
}
