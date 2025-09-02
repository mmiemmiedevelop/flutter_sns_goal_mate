class Comment {
  final String id;
  final String userId;
  final String postId;
  final String userNickname;
  final String userProfileImageUrl;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.userNickname,
    required this.userProfileImageUrl,
    required this.content,
    required this.createdAt,
  });

  // 댓글 수정용
  Comment copyWith({
    String? id,
    String? userId,
    String? postId,
    String? userNickname,
    String? userProfileImageUrl,
    String? content,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      userNickname: userNickname ?? this.userNickname,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
