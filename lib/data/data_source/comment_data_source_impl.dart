import 'package:flutter_princess/data/data_source/comment_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/dto/comment_dto.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final FirebaseFirestore firestore;

  CommentRemoteDataSourceImpl(this.firestore);

  // 댓글 불러오기
  @override
  Future<List<CommentDto>> fetchComments(String postId) async {
    final snapshot = await firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true) // 시간순 정렬
        .get();

    return snapshot.docs.map((doc) => CommentDto.fromJson(doc.data())).toList();
  }

  // 댓글 수 가져오기
  @override
  Future<int> getCommentCount(String postId) async {
    final snapshot = await firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  // 댓글 등록하기
  @override
  Future<void> addComment(CommentDto comment) async {
    // 댓글추가랑 댓글개수 증가 두개 같이 이루어지게 묶기
    await firestore.runTransaction((transaction) async {
      // 댓글 추가
      transaction.set(
        firestore.collection('comments').doc(comment.id),
        comment.toJson(),
      );

      // 포스트의 commentCount 증가
      final postRef = firestore.collection('post').doc(comment.postId);
      transaction.update(postRef, {'commentCount': FieldValue.increment(1)});
    });

    // 추가로 실제 댓글 수와 동기화
    await syncPostCommentCount(comment.postId);
  }

  // 댓글 수정
  @override
  Future<void> updateComment(CommentDto comment) async {
    await firestore
        .collection('comments')
        .doc(comment.id)
        .update(comment.toJson());
  }

  // 댓글 삭제
  @override
  Future<void> deleteComment(String commentId) async {
    // 먼저 댓글 정보를 가져와서 postId를 확인
    final commentDoc = await firestore
        .collection('comments')
        .doc(commentId)
        .get();
    if (!commentDoc.exists) return;

    final commentData = commentDoc.data()!;
    final postId = commentData['postId'] as String;

    // 댓글삭제랑 댓글개수 감소 두개 같이 이루어지게 묶기
    await firestore.runTransaction((transaction) async {
      // 댓글 삭제
      transaction.delete(firestore.collection('comments').doc(commentId));

      // 포스트의 commentCount 감소
      final postRef = firestore.collection('post').doc(postId);
      transaction.update(postRef, {'commentCount': FieldValue.increment(-1)});
    });

    // 추가로 실제 댓글 수와 동기화
    await syncPostCommentCount(postId);
  }

  // 포스트의 댓글 수를 실제 댓글 수로 동기화
  @override
  Future<void> syncPostCommentCount(String postId) async {
    // 실제 댓글 수 계산
    final actualCount = await getCommentCount(postId);

    // 포스트의 commentCount 필드를 실제 값으로 업데이트
    await firestore.collection('post').doc(postId).update({
      'commentCount': actualCount,
    });
  }
}
