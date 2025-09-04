import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/usecase/delete_post_usecase.dart';
import 'package:flutter_princess/domain/usecase/fetch_posts_usecase.dart';
import 'package:flutter_princess/domain/usecase/toggle_like_usecase.dart';
import 'package:flutter_princess/presentation/pages/provider/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, List<Post>>((ref) {
      return HomePageViewModel(
        ref.watch(fetchPostsUseCaseProvider),
        ref.watch(toggleLikeUseCaseProvider),
        ref.watch(deletePostUseCaseProvider),
      );
    });

class HomePageViewModel extends StateNotifier<List<Post>> {
  final FetchPostsUseCase _fetchPostsUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final DeletePostUseCase _deletePostUseCase;
  bool _isLoading = false;

  HomePageViewModel(
    this._fetchPostsUseCase,
    this._toggleLikeUseCase,
    this._deletePostUseCase,
  ) : super([]) {
    fetchNextPage();
  }

  // 다음 페이지의 게시물을 불러오는 함수 (무한 스크롤)
  Future<void> fetchNextPage() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final newPosts = await _fetchPostsUseCase.execute();
      state = [...state, ...newPosts];
    } catch (e) {
      print("Error fetching posts: $e");
    }
    _isLoading = false;
  }

  /// UI로부터 '좋아요' 상태 변경 요청을 처리하는 함수
  Future<bool> toggleLikeStatus(String postId, String currentUserId) async {
    // 일단 킵해두고
    final originalState = state;

    // UI 먼저 상태 변경 (성공한다는 전제하에)
    state = [
      for (final post in state)
        if (post.id == postId)
          post.toggleLike(currentUserId) // Post 객체 자체에 로직을 위임
        else
          post,
    ];

    try {
      // repository에게 firebase데이터도 변경 요청
      await _toggleLikeUseCase.execute(postId, currentUserId);
      return true;
    } catch (e) {
      print("Error toggling Like: $e");
      // 원상복구
      state = originalState;
      return false;
    }
  }

  // 게시글 삭제 함수
  Future<bool> deletePost(String postId) async {
    // 혹시 모르니까 일단 원래 상태 남겨두기
    final originalState = state;
    // state 리스트에서 postId가 일치하지 않는 게시물만 남겨서 새로운 리스트 만들기
    state = state.where((post) => post.id != postId).toList();
    try {
      await _deletePostUseCase.execute(postId);
      return true;
    } catch (e) {
      print("Error deleting post: $e");
      // 원상복구
      state = originalState;
      return false;
    }
  }

  // 새로고침
  Future<void> refresh() async {
    _isLoading = false; // 로딩중이어도 새로고침은 가능
    _fetchPostsUseCase.reset(); // repository에서 페이지네이션 상태 자체를 초기화
    state = [];
    await fetchNextPage();
  }

  // 모든 포스트의 댓글 수를 Firebase와 동기화
  Future<void> syncAllPostsCommentCount() async {
    for (final post in state) {
      try {
        // Firebase에서 최신 포스트 데이터를 가져와서 댓글 수 업데이트
        await refreshPostCommentCount(post.id);
      } catch (e) {
        print("Error syncing comment count for post ${post.id}: $e");
      }
    }
  }

  // Firebase에서 실시간으로 댓글 수 업데이트
  Future<void> refreshPostCommentCount(String postId) async {
    try {
      // Firebase에서 해당 포스트의 최신 데이터를 가져옴
      final updatedPosts = await _fetchPostsUseCase.getUpdatedPost(postId);
      if (updatedPosts != null) {
        // 해당 포스트만 업데이트
        state = [
          for (final post in state)
            if (post.id == postId) updatedPosts else post,
        ];
      }
    } catch (e) {
      print("Error refreshing post comment count: $e");
    }
  }

  // 댓글 수 업데이트 함수 (기존 방식도 유지)
  void updateCommentCount(String postId, int newCount) {
    state = [
      for (final post in state)
        if (post.id == postId) post.copyWith(commentCount: newCount) else post,
    ];
  }
}
