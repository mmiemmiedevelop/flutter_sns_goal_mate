import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/usecase/delete_post_usecase.dart';
import 'package:flutter_princess/domain/usecase/fetch_posts_usecase.dart';
import 'package:flutter_princess/domain/usecase/toggle_like_usecase.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_view_model_test.mocks.dart';

@GenerateMocks([FetchPostsUseCase, ToggleLikeUseCase, DeletePostUseCase])
void main() {
  late HomePageViewModel viewModel;
  late MockFetchPostsUseCase mockFetchPostsUseCase;
  late MockToggleLikeUseCase mockToggleLikeUseCase;
  late MockDeletePostUseCase mockDeletePostUseCase;

  // 테스트용 Post 헬퍼 함수
  Post createMockPost(
    String id, {
    List<String> likedBy = const [],
    int likeCount = 0,
  }) {
    return Post(
      id: id,
      userId: 'user-$id',
      userNickname: 'User $id',
      content: 'Content for $id',
      createdAt: DateTime.now(),
      likeCount: likeCount,
      likedBy: likedBy,
      userProfileImageUrl: '',
      imageUrls: [],
      tags: [],
      commentCount: 0,
    );
  }

  setUp(() {
    mockFetchPostsUseCase = MockFetchPostsUseCase();
    mockToggleLikeUseCase = MockToggleLikeUseCase();
    mockDeletePostUseCase = MockDeletePostUseCase();

    // 뷰모델 생성 시 초기 데이터 로딩을 모킹
    when(
      mockFetchPostsUseCase.execute(),
    ).thenAnswer((_) async => [createMockPost('1')]);

    viewModel = HomePageViewModel(
      mockFetchPostsUseCase,
      mockToggleLikeUseCase,
      mockDeletePostUseCase,
    );
  });

  group('HomePageViewModel', () {
    group('deletePost', () {
      test('성공 시 상태에서 게시물을 제거해야 한다', () async {
        // given
        const postId = '1';
        when(mockDeletePostUseCase.execute(postId)).thenAnswer((_) async {});

        // when
        final result = await viewModel.deletePost(postId);

        // then
        expect(result, isTrue);
        expect(viewModel.debugState.any((p) => p.id == postId), isFalse);
        verify(mockDeletePostUseCase.execute(postId)).called(1);
      });
    });

    group('toggleLikeStatus', () {
      test('성공 시 게시물의 좋아요 상태를 낙관적으로 업데이트해야 한다', () async {
        // given
        const postId = '1';
        const userId = 'liker';
        when(
          mockToggleLikeUseCase.execute(postId, userId),
        ).thenAnswer((_) async {});

        // when
        final future = viewModel.toggleLikeStatus(postId, userId);

        // then - 즉시 상태 변경 확인 (낙관적 업데이트)
        expect(viewModel.debugState.first.likeCount, 1);
        expect(viewModel.debugState.first.likedBy, contains(userId));

        final result = await future;
        expect(result, isTrue);
        verify(mockToggleLikeUseCase.execute(postId, userId)).called(1);
      });

      test('실패 시 상태를 원래대로 되돌려야 한다', () async {
        // given
        const postId = '1';
        const userId = 'liker';
        final originalState = viewModel.debugState;
        when(
          mockToggleLikeUseCase.execute(postId, userId),
        ).thenThrow(Exception('Error'));

        // when
        final result = await viewModel.toggleLikeStatus(postId, userId);

        // then
        expect(result, isFalse);
        expect(viewModel.debugState, originalState); // 상태가 롤백되었는지 확인
      });
    });
  });
}
