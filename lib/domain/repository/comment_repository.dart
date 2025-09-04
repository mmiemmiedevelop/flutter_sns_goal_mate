import 'package:flutter_princess/domain/entity/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<int> getCommentCount(String postId);
  Future<void> addComment(Comment comment);
  Future<void> updatedComment(Comment comment);
  Future<void> deleteComment(String commentId);
  // 포스트의 댓글 수를 실제 댓글 수로 동기화
  Future<void> syncPostCommentCount(String postId);
}
