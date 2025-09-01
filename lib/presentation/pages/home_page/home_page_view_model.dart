// 홈 페이지 뷰 모델

import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ViewModel을 제공하는 Provider (UI에서는 이 provider를 통해 ViewModel에 접근)
final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, List<Post>>((ref) {
      return HomePageViewModel();
    });

class HomePageViewModel extends StateNotifier<List<Post>> {
  // 일단 초기 상태로 가라 데이터 리스트를 가짐
  HomePageViewModel() : super(_mockPosts);

  // TODO: 이 부분은 나중에 Firestore에서 실제 데이터를 가져오는 로직으로 대체될 예정
  // (무한 스크롤 구현)
  void fetchNextPage() {
    // 현재 리스트에 가짜 데이터를 더 추가해서 무한 스크롤처럼 보이게 함
    state = [...state, ..._mockPosts];
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
  ),
];
