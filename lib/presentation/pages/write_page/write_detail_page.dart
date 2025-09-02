import 'package:flutter/material.dart';

class WriteDetailPage extends StatelessWidget {
  const WriteDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 상단 프로필 영역
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://static.cdn.kmong.com/gigs/jYcIZ1753511586.jpg?w=500',
                ),
              ),
              title: const Text(
                '나는짱이다',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 게시글 이미지
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 300,
                        child: Image.network(
                          'https://cdn.ardentnews.co.kr/news/photo/202403/2999_13749_5517.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 태그+좋아요
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '# 감성  # 사진',
                          style: TextStyle(fontSize: 17, letterSpacing: -0.5),
                        ),
                        Row(
                          children: const [
                            Text('0개', style: TextStyle(fontSize: 15)),
                            SizedBox(width: 6),
                            Icon(Icons.favorite_border, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 게시글 내용
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      '여행 곳곳마다 사진 찍기',
                      style: TextStyle(fontSize: 15, letterSpacing: -0.5),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  // 댓글 모두보기+시간
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '댓글 0개 모두 보기',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            color: Color(0xFFc5c5c5),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '7일 전',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFc5c5c5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(height: 10, color: const Color(0xFFeaeaea)),

                  // 댓글 영역
                  SizedBox(
                    height: 140,
                    child: Center(
                      child: Text(
                        '아직 댓글이 없어요',
                        style: TextStyle(
                          color: Color(0xFFc5c5c5),
                          fontSize: 15,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 하단 댓글 입력
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        'https://static.cdn.kmong.com/gigs/jYcIZ1753511586.jpg?w=500',
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 310,
                      child: Stack(
                        children: [
                          // 댓글 입력창
                          Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFeaeaea),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: '댓글을 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ),
                          // send 버튼
                          Positioned(
                            right: -4,
                            top: 2,
                            bottom: 2,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF613EEA),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
