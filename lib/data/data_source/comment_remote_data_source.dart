import 'package:flutter_princess/data/dto/comment_dto.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentDto>> fetchComments(String postId);
  Future<int> getCommentCount(String postId);
  Future<void> addComment(CommentDto comment);
  Future<void> updateComment(CommentDto comment);
  Future<void> deleteComment(String commentId);
  // 포스트의 댓글 수를 실제 댓글 수로 동기화
  Future<void> syncPostCommentCount(String postId);
}
