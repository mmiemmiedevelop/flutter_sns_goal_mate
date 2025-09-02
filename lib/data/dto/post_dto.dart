import 'package:cloud_firestore/cloud_firestore.dart';

/// Post Data Transfer Object (데이터 전송 객체)
/// Firestore와 직접 통신할 때 사용하는 데이터 모델!
/// 모든 필드는 Nullable('?')로 선언해야 함.
class PostDto {
  final String? userId;
  final String? userNickname;
  final String? userProfileImageUrl;
  final List<dynamic>? imageUrls;
  final List<dynamic>? tags;
  final String? content;
  final Timestamp? createdAt;
  final int? likeCount;
  final int? commentCount;
  final List<dynamic>? likedBy;

  PostDto({
    this.userId,
    this.userNickname,
    this.userProfileImageUrl,
    this.imageUrls,
    this.tags,
    this.content,
    this.createdAt,
    this.likeCount,
    this.commentCount,
    this.likedBy,
  });

  // Firestore Map -> PostDto
  factory PostDto.fromFirestore(Map<String, dynamic> data) {
    return PostDto(
      userId: data['userId'],
      userNickname: data['userNickname'],
      userProfileImageUrl: data['userProfileImageUrl'],
      imageUrls: data['imageUrls'],
      tags: data['tags'],
      content: data['content'],
      createdAt: data['createdAt'],
      likeCount: data['likeCount'],
      commentCount: data['commentCount'],
      likedBy: data['likedBy'],
    );
  }

  // PostDto -> Firestore Map
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
