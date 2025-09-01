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
}
