import 'package:flutter_princess/data/data_source/comment_remote_data_source.dart';
import 'package:flutter_princess/data/dto/comment_dto.dart';
import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  CommentRepositoryImpl(this.remoteDataSource);

  // 댓글 로드 구현
  @override
  Future<List<Comment>> getComments(String postId) async {
    final dtos = await remoteDataSource.fetchComments(postId);
    return dtos
        .map(
          (dto) => Comment(
            id: dto.id,
            userId: dto.userId,
            postId: dto.postId,
            userNickname: dto.userNickname,
            userProfileImageUrl: dto.userProfileImageUrl,
            content: dto.content,
            createdAt: dto.createdAt,
          ),
        )
        .toList();
  }

  // 댓글 등록 구현
  @override
  Future<void> addComment(Comment comment) async {
    final dto = CommentDto(
      id: comment.id,
      userId: comment.userId,
      postId: comment.postId,
      userNickname: comment.userNickname,
      userProfileImageUrl: comment.userProfileImageUrl,
      content: comment.content,
      createdAt: comment.createdAt,
    );
    await remoteDataSource.addComment(dto);
  }

  // 댓글 수정 구현
  @override
  Future<void> updatedComment(Comment comment) async {
    final dto = CommentDto(
      id: comment.id,
      userId: comment.userId,
      postId: comment.postId,
      userNickname: comment.userNickname,
      userProfileImageUrl: comment.userProfileImageUrl,
      content: comment.content,
      createdAt: comment.createdAt,
    );
    await remoteDataSource.updateComment(dto);
  }

  // 댓글 삭제 구현
  @override
  Future<void> deleteComment(String commentId) async {
    await remoteDataSource.deleteComment(commentId);
  }
}
