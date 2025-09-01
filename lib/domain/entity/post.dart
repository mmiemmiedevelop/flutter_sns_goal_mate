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

  Post copyWith({
    String? id,
    String? userId,
    String? userNickname,
    String? userProfileImageUrl,
    List<String>? imageUrls,
    List<String>? tags,
    String? content,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    List<String>? likedBy,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userNickname: userNickname ?? this.userNickname,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  Post toggleLike(String userId) {
    final isLiked = likedBy.contains(userId);
    final newLikedBy = List<String>.from(likedBy);
    int newLikeCount = likeCount;

    if (isLiked) {
      newLikedBy.remove(userId); // 좋아요 취소
      newLikeCount--;
    } else {
      newLikedBy.add(userId); // 좋아요
      newLikeCount++;
    }

    return copyWith(likedBy: newLikedBy, likeCount: newLikeCount);
  }
}
