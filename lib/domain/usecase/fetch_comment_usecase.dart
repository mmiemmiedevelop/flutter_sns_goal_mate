import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/repository/comment_repository.dart';

class FetchCommentUsecase {
  final CommentRepository repository;
  FetchCommentUsecase(this.repository);

  Future<List<Comment>> fetchComments(String postId) async {
    return await repository.getComments(postId);
  }

  Future<int> getCommentCount(String postId) async {
    return await repository.getCommentCount(postId);
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

  // 포스트의 댓글 수를 실제 댓글 수로 동기화
  Future<void> syncPostCommentCount(String postId) async {
    await repository.syncPostCommentCount(postId);
  }
}
