// 홈 페이지 뷰 모델

import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, List<Post>>((ref) {
      // TODO: 실제 Repository 주입
      // final repository = ref.watch(postRepositoryProvider);
      // return HomePageViewModel(repository);
      return HomePageViewModel();
    });

class HomePageViewModel extends StateNotifier<List<Post>> {
  HomePageViewModel() : super([]) {
    fetchNextPage();
  }

  // 다음 페이지의 게시물을 불러오는 함수 (무한 스크롤)
  Future<void> fetchNextPage() async {
    // TODO: 여기에 Firestore에서 데이터를 페이지 단위로 불러오는 로직을 구현할 예정

    // --- 현재는 UI 테스트를 위해 가짜(mock) 데이터를 추가하는 로ogic ---
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 통신처럼 보이게 1초 지연
    final morePosts = _mockPosts.map((p) {
      // 고유 ID를 만들기 위해 현재 state 길이를 이용
      final uniqueId = '${p.id}_${state.length}';
      return p.copyWith(id: uniqueId);
    }).toList();
    state = [...state, ...morePosts];
  }

  /// UI로부터 '좋아요' 상태 변경 요청을 처리하는 함수
  Future<void> toggleLikeStatus(String postId, String currentUserId) async {
    // TODO: Repository를 호출하여 Firestore 데이터를 실제로 업데이트하는 로직 추가
    // 1. postId의 좋아요 상태를 DB에 업데이트하라는 요청보내기
    // final success = await _repository.toggleLike(postId: postId, userId: currentUserId);
    // if (!success) { /* 만약 서버 업데이트가 실패하면, 원래 상태로 되돌리는 로직 추가 */ }

    // 2. 만약 서버 업데이트가 성공했다면, UI에 즉시 반영하기 위해 로컬 상태(state)도 직접 수정합니다.
    //    - Riverpod은 상태가 '불변(immutable)'이어야 하므로, 기존 리스트를 순회하며 새로운 리스트 만들기
    //    - postId가 일치하는 게시물을 찾으면, 그 게시물의 likedBy 리스트를 수정하여 새로운 Post 객체 생성하기
    //    - 일치하지 않는 게시물은 그대로 두기

    state = [
      for (final post in state)
        if (post.id == postId)
          post.toggleLike(currentUserId) // Post 객체 자체에 로직을 위임
        else
          post,
    ];
  }

  // 게ㅅ,ㅣ글 삭제 함수
  Future<void> deletePost(String postId) async {
    // state 리스트에서 postId가 일치하지 않는 게시물만 남겨서 새로운 리스트 만들기
    state = state.where((post) => post.id != postId).toList();

    // TODO: 여기에 Repository를 호출하여 Firestore 데이터를 실제로 삭제하는 로직 추가
    // await _repository.deletePost(postId: postId);
  }
}

// 가짜 데이터
final List<Post> _mockPosts = [
  Post(
    id: '1',
    userId: 'sorin_dev', // 나중에 실제 내 아이디와 비교해서 수정/삭제 버튼 표시
    userNickname: '정소린',
    userProfileImageUrl: 'https://placehold.co/100x100/F27272/FFFFFF?text=SR',
    imageUrls: [
      'https://picsum.photos/900/1600',
      'https://picsum.photos/900/1600',
    ],
    tags: ['#여행', '#일본', '#다카마쓰'],
    content:
        '다카마쓰에서 우동먹고 오기 성공! 맛있는 것도 많이 먹고 좋은 사람들과 좋은 시간을 보내서 행복했다. 다리는 부러졌지만! 🔥🔥🔥\n'
        '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
        '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
        '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n'
        '아주 긴 글 테스트입니다. 이 글은 화면을 넘어가야 합니다. 더보기 기능을 구현해야 하기 때문입니다. 인스타그램과 틱톡을 합친 멋진 앱을 만들어봅시다. 투둠나라 움바공주님들 화이팅하소서!\n',
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    likeCount: 102,
    commentCount: 15,
    likedBy: ['youngmin_kim'],
  ),
  Post(
    id: '2',
    userId: 'youngmin_kim',
    userNickname: '김영민',
    userProfileImageUrl: 'https://placehold.co/100x100/F27272/FFFFFF?text=YM',
    imageUrls: [
      'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=2070&auto=format&fit=crop',
    ],
    tags: ['#개발', '#코딩', '#목표달성'],
    content:
        'Flutter 프로젝트 GoalMate 시작! 클린 아키텍처를 적용해서 귀여운 앱을 만들어보는게 목표입니다. 다들 화이팅!',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    likeCount: 256,
    commentCount: 32,
    likedBy: ['video_lee', 'sorin_dev'],
  ),
  Post(
    id: '3',
    userId: 'video_lee',
    userNickname: '이영상',
    userProfileImageUrl: 'https://placehold.co/100x100/F27272/FFFFFF?text=YS',
    imageUrls: [
      'https://picsum.photos/id/58/1280/853.jpg',
      'https://picsum.photos/900/1600',
    ],
    tags: ['#영상', '#아이디어', '#목표달성', '#공주'],
    content:
        '안녕하세요 영상공주입니다. 투둠나라 백성들은 세금을 왜이리 적게 내는걸까? 어떻게 하면 더 걷을 수 있을까? 언제나 열심히 노력하는 대공주입니다.'
        '소공주님들도 열심히 하고 있지요? 공주수업 열심히 듣고 따라오셔야 저같은 완벽한 대공주가 될 수 있답니다. 뿌뿌',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    likeCount: 1004,
    commentCount: 1598,
    likedBy: ['sorin_dev'],
  ),
];

// Post 객체의 일부 필드만 쉽게 변경할 수 있도록 copyWith 메소드를 추가
extension PostCopyWith on Post {
  Post copyWith({String? id}) {
    return Post(
      id: id ?? this.id,
      userId: userId,
      userNickname: userNickname,
      userProfileImageUrl: userProfileImageUrl,
      imageUrls: imageUrls,
      content: content,
      tags: tags,
      likeCount: likeCount,
      commentCount: commentCount,
      createdAt: createdAt,
      likedBy: likedBy,
    );
  }
}
