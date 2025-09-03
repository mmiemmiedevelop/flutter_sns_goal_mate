import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_data_source.dart';
import 'package:flutter_princess/data/repository/post_repository_impl.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_repository_impl_test.mocks.dart';

// PostDataSource는 구현체가 아닌 추상 클래스를 모킹합니다.
@GenerateMocks([PostDataSource, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  late PostRepositoryImpl repository;
  late MockPostDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostDataSource();
    repository = PostRepositoryImpl(mockDataSource);
  });

  group('PostRepositoryImpl', () {
    group('fetchPosts', () {
      test('데이터 소스에서 데이터를 받아 List<Post>로 성공적으로 변환한다', () async {
        // arrange
        final mockDoc = MockQueryDocumentSnapshot<Object?>();
        final mockSnapshot = MockQuerySnapshot<Object?>();
        final postData = {
          'userId': 'test_user',
          'content': '테스트 내용',
          'createdAt': Timestamp.now(),
          'likeCount': 0,
          'commentCount': 0,
          'likedBy': [],
          'userNickname': '테스트',
          'userProfileImageUrl': '',
          'imageUrls': [],
          'tags': [],
        };

        when(
          mockDataSource.fetchPosts(lastDocument: null),
        ).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.docs).thenReturn([mockDoc]);
        when(mockDoc.id).thenReturn('post_id_1');
        when(mockDoc.data()).thenReturn(postData);

        // act
        final result = await repository.fetchPosts();

        // assert
        expect(result, isA<List<Post>>());
        expect(result.length, 1);
        expect(result.first.id, 'post_id_1');
        expect(result.first.content, '테스트 내용');
        verify(mockDataSource.fetchPosts(lastDocument: null)).called(1);
      });
    });
  });
}
