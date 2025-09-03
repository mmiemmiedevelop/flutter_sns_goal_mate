import 'package:flutter_princess/domain/entity/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<void> addComment(Comment comment);
  Future<void> updatedComment(Comment comment);
  Future<void> deleteComment(String commentId);
}
