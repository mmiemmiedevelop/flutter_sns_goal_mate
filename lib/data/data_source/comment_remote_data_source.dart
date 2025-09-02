import 'package:flutter_princess/data/dto/comment_dto.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentDto>> fetchComments(String postId);
  Future<void> addComment(CommentDto comment);
  Future<void> updateComment(CommentDto comment);
  Future<void> deleteComment(String commentId);
}
