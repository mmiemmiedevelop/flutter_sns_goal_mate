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
}

// // 가짜 데이터
// final List<Post> _mockPosts = [
//   Post(
//     id: '1',
//     userId: 'sorin_dev', // 나중에 실제 내 아이디와 비교해서 수정/삭제 버튼 표시
//     userNickname: '정소린',
//     userProfileImageUrl: 'https://picsum.photos/200/300',
//     imageUrls: [
//       'https://picsum.photos/900/1600',
//       'https://picsum.photos/900/1600',
//     ],
//     tags: ['#여행', '#일본', '#다카마쓰'],
//     content:
//         '다카마쓰에서 우동먹고 오기 성공! 맛있는 것도 많이 먹고 좋은 사람들과 좋은 시간을 보내서 행복했다. 다리는 부러졌지만! 🔥🔥🔥\n'
//         '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
//         '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
//         '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
//         '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n',
//     createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
//     likeCount: 102,
//     commentCount: 15,
//     likedBy: ['youngmin_kim'],
//   ),
//   Post(
//     id: '2',
//     userId: 'youngmin_kim',
//     userNickname: '김영민',
//     userProfileImageUrl: 'https://picsum.photos/200/300',

//     imageUrls: [
//       'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=2070&auto=format&fit=crop',
//     ],
//     tags: ['#개발', '#코딩', '#목표달성'],
//     content:
//         'Flutter 프로젝트 GoalMate 시작! 클린 아키텍처를 적용해서 귀여운 앱을 만들어보는게 목표입니다. 다들 화이팅!',
//     createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//     likeCount: 256,
//     commentCount: 32,
//     likedBy: ['video_lee', 'sorin_dev'],
//   ),
//   Post(
//     id: '3',
//     userId: 'video_lee',
//     userNickname: '이영상',
//     userProfileImageUrl: 'https://picsum.photos/200/300',

//     imageUrls: [
//       'https://picsum.photos/id/58/1280/853.jpg',
//       'https://picsum.photos/900/1600',
//     ],
//     tags: ['#영상', '#아이디어', '#목표달성', '#공주'],
//     content:
//         '안녕하세요 영상공주입니다. 투둠나라 백성들은 세금을 왜이리 적게 내는걸까? 어떻게 하면 더 걷을 수 있을까? 언제나 열심히 노력하는 대공주입니다.'
//         '소공주님들도 열심히 하고 있지요? 공주수업 열심히 듣고 따라오셔야 저같은 완벽한 대공주가 될 수 있답니다. 뿌뿌',
//     createdAt: DateTime.now().subtract(const Duration(days: 2)),
//     likeCount: 1004,
//     commentCount: 1598,
//     likedBy: ['sorin_dev'],
//   ),
// ];

// // Post 객체의 일부 필드만 쉽게 변경할 수 있도록 copyWith 메소드를 추가
// extension PostCopyWith on Post {
//   Post copyWith({String? id}) {
//     return Post(
//       id: id ?? this.id,
//       userId: userId,
//       userNickname: userNickname,
//       userProfileImageUrl: userProfileImageUrl,
//       imageUrls: imageUrls,
//       content: content,
//       tags: tags,
//       likeCount: likeCount,
//       commentCount: commentCount,
//       createdAt: createdAt,
//       likedBy: likedBy,
//     );
//   }
// }
