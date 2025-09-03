import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_princess/data/data_source/comment_remote_data_source.dart';
import 'package:flutter_princess/data/dto/comment_dto.dart';
import 'package:flutter_princess/data/repository/comment_repository_impl.dart';
import 'package:flutter_princess/domain/entity/comment.dart';

import 'comment_repository_impl_test.mocks.dart';

@GenerateMocks([CommentRemoteDataSource])
void main() {
  late CommentRepositoryImpl repository;
  late MockCommentRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockCommentRemoteDataSource();
    repository = CommentRepositoryImpl(mockRemoteDataSource);
  });

  group('CommentRepositoryImpl', () {
    final testPostId = 'test-post-id';
    final testCommentId = 'test-comment-id';
    final testDateTime = DateTime(2024, 1, 1, 12, 0, 0);

    final testCommentDto = CommentDto(
      id: testCommentId,
      userId: 'test-user-id',
      postId: testPostId,
      userNickname: 'testuser',
      userProfileImageUrl: 'https://example.com/profile.jpg',
      content: '테스트 댓글 내용',
      createdAt: testDateTime,
    );

    final testComment = Comment(
      id: testCommentId,
      userId: 'test-user-id',
      postId: testPostId,
      userNickname: 'testuser',
      userProfileImageUrl: 'https://example.com/profile.jpg',
      content: '테스트 댓글 내용',
      createdAt: testDateTime,
    );

    group('getComments', () {
      test('포스트 ID로 댓글 목록을 성공적으로 가져온다', () async {
        // arrange
        final dtoList = [testCommentDto];
        when(
          mockRemoteDataSource.fetchComments(testPostId),
        ).thenAnswer((_) async => dtoList);

        // act
        final result = await repository.getComments(testPostId);

        // assert
        expect(result, isA<List<Comment>>());
        expect(result.length, 1);
        expect(result.first.id, testComment.id);
        expect(result.first.userId, testComment.userId);
        expect(result.first.postId, testComment.postId);
        expect(result.first.userNickname, testComment.userNickname);
        expect(
          result.first.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(result.first.content, testComment.content);
        expect(result.first.createdAt, testComment.createdAt);
        verify(mockRemoteDataSource.fetchComments(testPostId)).called(1);
      });

      test('빈 댓글 목록을 반환한다', () async {
        // arrange
        when(
          mockRemoteDataSource.fetchComments(testPostId),
        ).thenAnswer((_) async => []);

        // act
        final result = await repository.getComments(testPostId);

        // assert
        expect(result, isA<List<Comment>>());
        expect(result.isEmpty, true);
        verify(mockRemoteDataSource.fetchComments(testPostId)).called(1);
      });

      test('데이터 소스에서 에러가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRemoteDataSource.fetchComments(testPostId),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => repository.getComments(testPostId), throwsException);
        verify(mockRemoteDataSource.fetchComments(testPostId)).called(1);
      });
    });

    group('addComment', () {
      test('댓글을 성공적으로 추가한다', () async {
        // arrange
        when(mockRemoteDataSource.addComment(any)).thenAnswer((_) async => {});

        // act
        await repository.addComment(testComment);

        // assert
        verify(
          mockRemoteDataSource.addComment(
            argThat(
              predicate<CommentDto>(
                (dto) =>
                    dto.id == testComment.id &&
                    dto.userId == testComment.userId &&
                    dto.postId == testComment.postId &&
                    dto.userNickname == testComment.userNickname &&
                    dto.userProfileImageUrl ==
                        testComment.userProfileImageUrl &&
                    dto.content == testComment.content &&
                    dto.createdAt == testComment.createdAt,
              ),
            ),
          ),
        ).called(1);
      });

      test('데이터 소스에서 에러가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRemoteDataSource.addComment(any),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => repository.addComment(testComment), throwsException);
      });
    });

    group('updatedComment', () {
      test('댓글을 성공적으로 수정한다', () async {
        // arrange
        when(
          mockRemoteDataSource.updateComment(any),
        ).thenAnswer((_) async => {});

        // act
        await repository.updatedComment(testComment);

        // assert
        verify(
          mockRemoteDataSource.updateComment(
            argThat(
              predicate<CommentDto>(
                (dto) =>
                    dto.id == testComment.id &&
                    dto.userId == testComment.userId &&
                    dto.postId == testComment.postId &&
                    dto.userNickname == testComment.userNickname &&
                    dto.userProfileImageUrl ==
                        testComment.userProfileImageUrl &&
                    dto.content == testComment.content &&
                    dto.createdAt == testComment.createdAt,
              ),
            ),
          ),
        ).called(1);
      });

      test('데이터 소스에서 에러가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRemoteDataSource.updateComment(any),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => repository.updatedComment(testComment), throwsException);
      });
    });

    group('deleteComment', () {
      test('댓글을 성공적으로 삭제한다', () async {
        // arrange
        when(
          mockRemoteDataSource.deleteComment(testCommentId),
        ).thenAnswer((_) async => {});

        // act
        await repository.deleteComment(testCommentId);

        // assert
        verify(mockRemoteDataSource.deleteComment(testCommentId)).called(1);
      });

      test('데이터 소스에서 에러가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRemoteDataSource.deleteComment(testCommentId),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => repository.deleteComment(testCommentId), throwsException);
      });
    });
  });
}
