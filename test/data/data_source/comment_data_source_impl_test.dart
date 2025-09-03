import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/comment_data_source_impl.dart';
import 'package:flutter_princess/data/dto/comment_dto.dart';

import 'comment_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late CommentRemoteDataSourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    dataSource = CommentRemoteDataSourceImpl(mockFirestore);
  });

  group('CommentRemoteDataSourceImpl', () {
    final testCommentDto = CommentDto(
      id: 'test_comment_id',
      userId: 'test_user_id',
      postId: 'test_post_id',
      userNickname: 'testUser',
      userProfileImageUrl: 'https://example.com/profile.jpg',
      content: '테스트 댓글입니다',
      createdAt: DateTime.now(),
    );

    group('fetchComments', () {
      test('특정 포스트의 댓글 목록을 성공적으로 가져온다', () async {
        // Given
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final commentData = testCommentDto.toJson();

        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.where('postId', isEqualTo: 'test_post_id'),
        ).thenReturn(mockQuery);
        when(
          mockQuery.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc]);
        when(mockDoc.data()).thenReturn(commentData);

        // When
        final result = await dataSource.fetchComments('test_post_id');

        // Then
        expect(result, isA<List<CommentDto>>());
        expect(result.length, 1);
        expect(result.first.id, testCommentDto.id);
        expect(result.first.postId, 'test_post_id');
        expect(result.first.content, testCommentDto.content);

        verify(mockFirestore.collection('comments')).called(1);
        verify(
          mockCollection.where('postId', isEqualTo: 'test_post_id'),
        ).called(1);
        verify(mockQuery.orderBy('createdAt', descending: true)).called(1);
        verify(mockQuery.get()).called(1);
      });

      test('댓글이 없는 경우 빈 리스트를 반환한다', () async {
        // Given
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.where('postId', isEqualTo: 'empty_post_id'),
        ).thenReturn(mockQuery);
        when(
          mockQuery.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // When
        final result = await dataSource.fetchComments('empty_post_id');

        // Then
        expect(result, isEmpty);
        verify(mockFirestore.collection('comments')).called(1);
      });

      test('Firestore 에러가 발생하면 예외를 던진다', () async {
        // Given
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.where('postId', isEqualTo: 'test_post_id'),
        ).thenReturn(mockQuery);
        when(
          mockQuery.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // When & Then
        expect(
          () => dataSource.fetchComments('test_post_id'),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('addComment', () {
      test('댓글을 성공적으로 추가한다', () async {
        // Given
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.doc(testCommentDto.id),
        ).thenReturn(mockDocumentReference);
        when(mockDocumentReference.set(any)).thenAnswer((_) async => {});

        // When
        await dataSource.addComment(testCommentDto);

        // Then
        verify(mockFirestore.collection('comments')).called(1);
        verify(mockCollection.doc(testCommentDto.id)).called(1);
        verify(mockDocumentReference.set(testCommentDto.toJson())).called(1);
      });

      test('댓글 추가 시 Firestore 에러가 발생하면 예외를 던진다', () async {
        // Given
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.doc(testCommentDto.id),
        ).thenReturn(mockDocumentReference);
        when(mockDocumentReference.set(any)).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // When & Then
        expect(
          () => dataSource.addComment(testCommentDto),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('updateComment', () {
      test('댓글을 성공적으로 수정한다', () async {
        // Given
        final updatedComment = CommentDto(
          id: testCommentDto.id,
          userId: testCommentDto.userId,
          postId: testCommentDto.postId,
          userNickname: testCommentDto.userNickname,
          userProfileImageUrl: testCommentDto.userProfileImageUrl,
          content: '수정된 댓글입니다',
          createdAt: testCommentDto.createdAt,
        );

        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.doc(updatedComment.id),
        ).thenReturn(mockDocumentReference);
        when(mockDocumentReference.update(any)).thenAnswer((_) async => {});

        // When
        await dataSource.updateComment(updatedComment);

        // Then
        verify(mockFirestore.collection('comments')).called(1);
        verify(mockCollection.doc(updatedComment.id)).called(1);
        verify(mockDocumentReference.update(updatedComment.toJson())).called(1);
      });

      test('댓글 수정 시 Firestore 에러가 발생하면 예외를 던진다', () async {
        // Given
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(
          mockCollection.doc(testCommentDto.id),
        ).thenReturn(mockDocumentReference);
        when(mockDocumentReference.update(any)).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'Document not found',
          ),
        );

        // When & Then
        expect(
          () => dataSource.updateComment(testCommentDto),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('deleteComment', () {
      test('댓글을 성공적으로 삭제한다', () async {
        // Given
        const commentId = 'test_comment_id';
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(mockCollection.doc(commentId)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.delete()).thenAnswer((_) async => {});

        // When
        await dataSource.deleteComment(commentId);

        // Then
        verify(mockFirestore.collection('comments')).called(1);
        verify(mockCollection.doc(commentId)).called(1);
        verify(mockDocumentReference.delete()).called(1);
      });

      test('댓글 삭제 시 Firestore 에러가 발생하면 예외를 던진다', () async {
        // Given
        const commentId = 'test_comment_id';
        when(mockFirestore.collection('comments')).thenReturn(mockCollection);
        when(mockCollection.doc(commentId)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.delete()).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // When & Then
        expect(
          () => dataSource.deleteComment(commentId),
          throwsA(isA<FirebaseException>()),
        );
      });
    });
  });
}
