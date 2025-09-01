import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/repository/comment_repository.dart';

class FetchCommentUsecase {
  final CommentRepository repository;
  FetchCommentUsecase(this.repository);

  Future<List<Comment>> fetchComments(String postId) async {
    return await repository.getComments(postId);
  }

  Future<void> addComment(Comment comment) async {
    await repository.addComment(comment);
  }

  Future<void> updateComment(Comment comment) async {
    await repository.updatedComment(comment);
  }

  Future<void> deleteComment(String commentId) async {
    await repository.deleteComment(commentId);
  }
}
