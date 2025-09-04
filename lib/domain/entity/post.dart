import 'package:cloud_firestore/cloud_firestore.dart';

// entity: 앱의 Domain/Presentation 레이어에서 사용하는 핵심 데이터 모델
class Post {
  final String id;
  final String userId;
  final String userNickname;
  final String userProfileImageUrl;
  final List<String> imageUrls;
  final List<String> tags;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final List<String> likedBy;

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

  // Firestore의 Map 데이터와 문서 ID를 받아 Post 객체로 변환하는 팩토리 생성자
  factory Post.fromFirestore(Map<String, dynamic> data, String documentId) {
    final imageUrlFromDb = data['userProfileImageUrl'] as String?;

    return Post(
      id: documentId,
      userId: data['userId'] ?? '',
      userNickname: data['userNickname'] ?? '알 수 없음',
      userProfileImageUrl: (imageUrlFromDb == null || imageUrlFromDb.isEmpty)
          ? 'assets/img/default_profile.jpg'
          : imageUrlFromDb,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      content: data['content'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  // 좋아요 상태 뒤집기
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

  // 객체 일부필드만 변경하여 새로운 복사본 만들어주는 헬퍼 메서드
  Post copyWith({String? id, int? likeCount, List<String>? likedBy}) {
    return Post(
      id: id ?? this.id,
      userId: userId,
      userNickname: userNickname,
      userProfileImageUrl: userProfileImageUrl,
      imageUrls: imageUrls,
      tags: tags,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}

// 업로드
extension PostJson on Post {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userNickname': userNickname,
      'userProfileImageUrl': userProfileImageUrl,
      'imageUrls': imageUrls,
      'tags': tags,
      'content': content,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'likedBy': likedBy,
    };
  }
}
