import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';
import 'package:flutter_princess/domain/usecase/fetch_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_posts_usecase_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late FetchPostsUseCase usecase;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    usecase = FetchPostsUseCase(mockRepository);
  });

  group('FetchPostsUseCase', () {
    test('Repository의 fetchPosts를 호출하고 결과를 반환해야 한다', () async {
      // arrange
      final expectedPosts = <Post>[];
      when(mockRepository.fetchPosts()).thenAnswer((_) async => expectedPosts);

      // act
      final result = await usecase.execute();

      // assert
      expect(result, expectedPosts);
      verify(mockRepository.fetchPosts()).called(1);
    });
  });
}
