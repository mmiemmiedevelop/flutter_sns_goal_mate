import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/repository/comment_repository.dart';
import 'package:flutter_princess/domain/usecase/fetch_comment_usecase.dart';

import 'fetch_comment_usecase_test.mocks.dart';

@GenerateMocks([CommentRepository])
void main() {
  late FetchCommentUsecase usecase;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    usecase = FetchCommentUsecase(mockRepository);
  });

  group('FetchCommentUsecase', () {
    final testPostId = 'test-post-id';
    final testCommentId = 'test-comment-id';
    final testDateTime = DateTime(2024, 1, 1, 12, 0, 0);

    final testComment = Comment(
      id: testCommentId,
      userId: 'test-user-id',
      postId: testPostId,
      userNickname: 'testuser',
      userProfileImageUrl: 'https://example.com/profile.jpg',
      content: '테스트 댓글 내용',
      createdAt: testDateTime,
    );

    group('fetchComments', () {
      test('포스트 ID로 댓글 목록을 성공적으로 가져온다', () async {
        // arrange
        final commentList = [testComment];
        when(
          mockRepository.getComments(testPostId),
        ).thenAnswer((_) async => commentList);

        // act
        final result = await usecase.fetchComments(testPostId);

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
        verify(mockRepository.getComments(testPostId)).called(1);
      });

      test('빈 댓글 목록을 반환한다', () async {
        // arrange
        when(
          mockRepository.getComments(testPostId),
        ).thenAnswer((_) async => []);

        // act
        final result = await usecase.fetchComments(testPostId);

        // assert
        expect(result, isA<List<Comment>>());
        expect(result.isEmpty, true);
        verify(mockRepository.getComments(testPostId)).called(1);
      });

      test('여러 댓글을 정상적으로 반환한다', () async {
        // arrange
        final comment2 = testComment.copyWith(
          id: 'test-comment-id-2',
          content: '두 번째 댓글',
        );
        final commentList = [testComment, comment2];
        when(
          mockRepository.getComments(testPostId),
        ).thenAnswer((_) async => commentList);

        // act
        final result = await usecase.fetchComments(testPostId);

        // assert
        expect(result.length, 2);
        expect(result[0].content, '테스트 댓글 내용');
        expect(result[1].content, '두 번째 댓글');
        verify(mockRepository.getComments(testPostId)).called(1);
      });

      test('repository에서 예외가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRepository.getComments(testPostId),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => usecase.fetchComments(testPostId), throwsException);
        verify(mockRepository.getComments(testPostId)).called(1);
      });
    });

    group('addComment', () {
      test('댓글을 성공적으로 추가한다', () async {
        // arrange
        when(
          mockRepository.addComment(testComment),
        ).thenAnswer((_) async => {});

        // act
        await usecase.addComment(testComment);

        // assert
        verify(mockRepository.addComment(testComment)).called(1);
      });

      test('repository에서 예외가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRepository.addComment(testComment),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => usecase.addComment(testComment), throwsException);
        verify(mockRepository.addComment(testComment)).called(1);
      });
    });

    group('updateComment', () {
      test('댓글을 성공적으로 수정한다', () async {
        // arrange
        final updatedComment = testComment.copyWith(content: '수정된 댓글 내용');
        when(
          mockRepository.updatedComment(updatedComment),
        ).thenAnswer((_) async => {});

        // act
        await usecase.updateComment(updatedComment);

        // assert
        verify(mockRepository.updatedComment(updatedComment)).called(1);
      });

      test('repository에서 예외가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRepository.updatedComment(testComment),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => usecase.updateComment(testComment), throwsException);
        verify(mockRepository.updatedComment(testComment)).called(1);
      });
    });

    group('deleteComment', () {
      test('댓글을 성공적으로 삭제한다', () async {
        // arrange
        when(
          mockRepository.deleteComment(testCommentId),
        ).thenAnswer((_) async => {});

        // act
        await usecase.deleteComment(testCommentId);

        // assert
        verify(mockRepository.deleteComment(testCommentId)).called(1);
      });

      test('repository에서 예외가 발생하면 예외를 전파한다', () async {
        // arrange
        when(
          mockRepository.deleteComment(testCommentId),
        ).thenThrow(Exception('네트워크 에러'));

        // act & assert
        expect(() => usecase.deleteComment(testCommentId), throwsException);
        verify(mockRepository.deleteComment(testCommentId)).called(1);
      });
    });
  });
}
