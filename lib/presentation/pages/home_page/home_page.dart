// lib/presentation/pages/home_page/home_page.dart

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/presentation/common_widget/util/formatters.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_princess/presentation/pages/user_view_model.dart/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(homePageViewModelProvider);
    final pageController = PageController();

    return Scaffold(
      // PageView.builder를 사용하여 틱톡처럼 위아래로 스크롤되는 피드를 만듬
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical, // 스크롤 방향을 수직으로 설정
        itemCount: posts.length,
        // 무한 스크롤: 페이지가 거의 끝에 도달했을 때 다음 데이터를 불러오기
        onPageChanged: (index) {
          if (index == posts.length - 2) {
            ref.read(homePageViewModelProvider.notifier).fetchNextPage();
          }
        },
        itemBuilder: (context, index) {
          return PostItem(post: posts[index]);
        },
      ),
    );
  }
}

// 게시물 하나를 표시하는 위젯
class PostItem extends ConsumerStatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  ConsumerState<PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem> {
  // 본문 더보기/접기 상태
  bool _isExpanded = false;
  // // 좋아요 상태
  // bool _isLiked = false;
  // // 좋아요 숫자 변경을 위한 상태 변수
  // late int _currentLikeCount;

  // @override
  // void initState() {
  //   super.initState();
  //   _currentLikeCount = widget.post.likeCount;
  // }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateViewmodelProvider);
    // 현재 로그인한 유저 ID (임시)
    const currentUserId = 'sorin_dev';
    final isMyPost = widget.post.userId == currentUserId;

    // 좋아요 여부 서버에서 받아서 체크
    final bool isLiked = widget.post.likedBy.contains(currentUserId);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. 배경 이미지 (좌우 스크롤 가능)
        _buildBackgroundImage(),

        // 2. 상단 UI (앱 이름, 프로필, 닉네임, 작성 시간, 설정 버튼)
        _buildTopBar(context, isMyPost),

        // 3. 우측 액션 버튼 (글쓰기, 좋아요, 댓글)
        _buildActionButtons(context, isLiked),

        // 4. 하단 정보 UI (태그, 내용, 수정/삭제 버튼)
        _buildBottomContent(context, isMyPost),
        Center(child: Text(userState!.email)),
      ],
    );
  }

  // 1. 배경 이미지 PageView
  Widget _buildBackgroundImage() {
    return PageView.builder(
      itemCount: widget.post.imageUrls.length,
      itemBuilder: (context, imageIndex) {
        return CachedNetworkImage(
          imageUrl: widget.post.imageUrls[imageIndex],
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[300]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }

  // 2. 상단 UI
  Widget _buildTopBar(BuildContext context, bool isMyPost) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GoalMate',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (isMyPost)
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () => context.go('/setting'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 프로필, 닉네임, 작성 시간
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(
                  widget.post.userProfileImageUrl,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.userNickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black54)],
                    ),
                  ),
                  Text(
                    formatTimestamp(widget.post.createdAt),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black54)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. 우측 액션 버튼
  Widget _buildActionButtons(BuildContext context, bool isLiked) {
    return Positioned(
      bottom: 240,
      right: 16,
      child: Column(
        children: [
          // 글 작성 버튼 (과제 요구사항은 하단 가운데였으나, 틱톡 스타일에서는 우측에 위치)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              color: Colors.deepPurple,
              child: InkWell(
                onTap: () => context.go('/write'),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 좋아요 버튼
          _buildActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            // text: formatNumber(_currentLikeCount),
            text: formatNumber(widget.post.likeCount),

            color: isLiked ? Colors.red : Colors.white,
            onTap: () {
              // setState(() {
              //   isLiked = !isLiked;
              //   if (_isLiked) {
              //     currentLikeCount++;
              //   } else {
              //     currentLikeCount--;
              //   }
              // });
              // TODO: ViewModel에 좋아요 상태 업데이트 요청 로직 추가
              ref
                  .read(homePageViewModelProvider.notifier)
                  .toggleLikeStatus(widget.post.id);
            },
          ),
          const SizedBox(height: 20),
          // 댓글 버튼
          _buildActionButton(
            icon: Icons.comment,
            text: formatNumber(widget.post.commentCount),
            color: Colors.white,
            onTap: () => context.go('/comment/${widget.post.id}'),
          ),
        ],
      ),
    );
  }

  // 액션 버튼 (아이콘 + 텍스트) 생성용 함수
  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 35,
            shadows: [const Shadow(blurRadius: 2, color: Colors.black54)],
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
            ),
          ),
        ],
      ),
    );
  }

  // 4. 하단 정보 UI
  Widget _buildBottomContent(BuildContext context, bool isMyPost) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        // 내용이 길 때 본문 박스 확장/축소
        onTap: () {
          if (widget.post.content.length > 50) {
            //일단 50자
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: _isExpanded ? MediaQuery.of(context).size.height * 0.6 : 220,
          // ClipRRect & BackdropFilter: 배경을 흐리게 만드는 블러(Frosted Glass) 효과
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              // 박스 확장할때 배경색을 더 진하게 변경
              child: Container(
                padding: const EdgeInsets.all(16),
                color: _isExpanded ? Colors.black54 : Colors.black38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 태그와 수정/삭제 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 태그들을 표시하는 Wrap 위젯. 공간이 부족하면 자동으로 줄바꿈
                        Expanded(
                          // 버튼에 공간을 뺏기지 않도록 남은 공간을 모두 차지
                          child: Wrap(
                            spacing: 8.0, // 태그 사이의 수평 간격
                            runSpacing: 4.0, // 태그 줄 사이의 수직 간격
                            children: widget.post.tags
                                .map(
                                  (tag) => Text(
                                    tag,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        // 내 게시물일 경우에만 '...' 버튼을 표시
                        if (isMyPost)
                          Builder(
                            builder: (builderContext) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // showModalBottomSheet: 화면 아래에서 올라오는 옵션 메뉴(바텀 시트)를 표시
                                  showModalBottomSheet(
                                    context: builderContext,
                                    backgroundColor: Colors.white,
                                    builder: (bottomSheetContext) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: 8,
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).padding.bottom +
                                              8,
                                        ),
                                        child: Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: const Text('게시글 수정'),
                                              onTap: () {
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                );
                                                // 수정 페이지로 이동. extra로 현재 게시물 데이터를 전달
                                                context.push(
                                                  '/write',
                                                  extra: widget.post,
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.delete),
                                              title: const Text('게시글 삭제'),
                                              onTap: () {
                                                Navigator.pop(
                                                  bottomSheetContext,
                                                );
                                                // TODO: ViewModel에 삭제 요청 로직 추가
                                                print('삭제 기능 구현 필요');
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 본문 내용
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.post.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          maxLines: _isExpanded
                              ? 100
                              : 3, // 확장 시 최대 100줄, 축소 시 3줄
                          overflow:
                              TextOverflow.ellipsis, // 내용이 넘칠 경우 '...'으로 표시
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
