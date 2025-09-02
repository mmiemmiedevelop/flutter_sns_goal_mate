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
        .orderBy('createdAt', descending: false) // 시간순 정렬
        .get();

    return snapshot.docs.map((doc) => CommentDto.fromJson(doc.data())).toList();
  }

  // 댓글 등록하기
  @override
  Future<void> addComment(CommentDto comment) async {
    await firestore
        .collection('comments')
        .doc(comment.id)
        .set(comment.toJson());
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
    await firestore.collection('comments').doc(commentId).delete();
  }
}
