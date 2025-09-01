class Post {
  final String id;
  final String userId;
  final String userNickname;
  final String userProfileImageUrl;
  final List<String> imageUrls; // 여러 장의 사진을 위함
  final List<String> tags;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final List<String> likedBy; // '좋아요'를 누른 유저 ID 목록

  Post({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.userProfileImageUrl,
    required this.imageUrls,
    required this.tags,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.likedBy,
  });

  // Firestore의 Map 데이터를 Post 객체로 변환하는 팩토리 생성자
  factory Post.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Post(
      id: documentId,
      userId: data['userId'] ?? '',
      userNickname: data['userNickname'] ?? '알 수 없음',
      userProfileImageUrl: data['userProfileImageUrl'] ?? '기본_이미지_URL',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      content: data['content'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      // Firestore의 Timestamp는 toDate()로 DateTime으로 변환해야 한다고 함
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }
}
