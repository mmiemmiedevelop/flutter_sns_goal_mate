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
  }); // likedBy 필드를 안전하게 파싱하는 헬퍼 메서드
  static List<String> _parseLikedBy(dynamic likedByData) {
    if (likedByData == null) {
      return [];
    }

    // 이미 리스트인 경우
    if (likedByData is List) {
      return List<String>.from(likedByData);
    }

    // 문자열인 경우 (잘못된 데이터 형식)
    if (likedByData is String) {
      // 빈 문자열이면 빈 리스트 반환
      if (likedByData.isEmpty) {
        return [];
      }
      // 콤마로 구분된 문자열이라고 가정하고 분리 (또는 단일 항목으로 처리)
      if (likedByData.contains(',')) {
        return likedByData.split(',').map((e) => e.trim()).toList();
      } else {
        return [likedByData];
      }
    }

    // 다른 타입인 경우 빈 리스트 반환
    return [];
  }

  // 문자열 리스트 필드를 안전하게 파싱하는 헬퍼 메서드 (imageUrls, tags 등)
  static List<String> _parseStringList(dynamic listData) {
    if (listData == null) {
      return [];
    }

    // 이미 리스트인 경우
    if (listData is List) {
      return List<String>.from(listData);
    }

    // 문자열인 경우
    if (listData is String) {
      if (listData.isEmpty) {
        return [];
      }
      // 콤마로 구분된 문자열이라고 가정하고 분리
      if (listData.contains(',')) {
        return listData.split(',').map((e) => e.trim()).toList();
      } else {
        return [listData];
      }
    }

    // 다른 타입인 경우 빈 리스트 반환
    return [];
  }

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
      imageUrls: _parseStringList(data['imageUrls']),
      content: data['content'] ?? '',
      tags: _parseStringList(data['tags']),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      likedBy: _parseLikedBy(data['likedBy']),
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
