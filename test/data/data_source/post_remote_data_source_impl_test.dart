import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late PostRemoteDataSourceImpl dataSource;
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
    dataSource = PostRemoteDataSourceImpl(mockFirestore);

    // 공통적인 Firestore 호출 체인 모킹
    when(mockFirestore.collection('post')).thenReturn(mockCollection);
  });

  group('PostRemoteDataSourceImpl', () {
    group('fetchPosts', () {
      test('게시물 목록을 성공적으로 가져온다', () async {
        // Given
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        final postData = {
          'userId': 'test_user',
          'content': '테스트 게시물',
          'createdAt': Timestamp.now(),
        };

        when(
          mockCollection.orderBy('createdAt', descending: true),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(5)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockDoc]);
        when(mockDoc.data()).thenReturn(postData);

        // When
        final result = await dataSource.fetchPosts();

        // Then
        expect(result, isA<QuerySnapshot>());
        expect(result.docs.length, 1);
        verify(mockCollection.orderBy('createdAt', descending: true)).called(1);
        verify(mockQuery.limit(5)).called(1);
        verify(mockQuery.get()).called(1);
      });
    });

    group('deletePost', () {
      test('게시물을 성공적으로 삭제한다', () async {
        // Given
        const postId = 'test_post_id';
        when(mockCollection.doc(postId)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.delete()).thenAnswer((_) async => {});

        // When
        await dataSource.deletePost(postId);

        // Then
        verify(mockCollection.doc(postId)).called(1);
        verify(mockDocumentReference.delete()).called(1);
      });

      test('게시물 삭제 시 Firestore 에러가 발생하면 예외를 던진다', () async {
        // Given
        const postId = 'test_post_id';
        when(mockCollection.doc(postId)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.delete()).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );

        // When & Then
        expect(
          () => dataSource.deletePost(postId),
          throwsA(isA<FirebaseException>()),
        );
      });
    });

    group('toggleLike', () {
      test('좋아요 상태 변경을 위해 트랜잭션을 실행한다', () async {
        // Given
        const postId = 'test_post_id';
        const userId = 'test_user_id';

        /// 오옹 '  final postRef = _postsCollection.doc(postId); ' 이 부분에 대한 테스트가 빠져있다고 함.
        /// dox()에 대해서 테스트 안했다고 MissingStubError라고 뜸
        when(mockCollection.doc(postId)).thenReturn(mockDocumentReference);

        when(mockFirestore.runTransaction(any)).thenAnswer((_) async => null);

        // When
        await dataSource.toggleLike(postId, userId);

        // Then
        /// doc이 호출되었는지 검증하도록 추가함
        verify(mockCollection.doc(postId)).called(1);

        verify(mockFirestore.runTransaction(any)).called(1);
      });
    });
  });
}
