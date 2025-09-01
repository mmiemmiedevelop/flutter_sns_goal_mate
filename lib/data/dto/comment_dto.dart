class CommentDto {
  final String id;
  final String userId;
  final String postId;
  final String userNickname;
  final String userProfileImageUrl;
  final String content;
  final DateTime createdAt;

  CommentDto({
    required this.id,
    required this.userId,
    required this.postId,
    required this.userNickname,
    required this.userProfileImageUrl,
    required this.content,
    required this.createdAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      id: json["id"] as String,
      userId: json["userId"] as String,
      postId: json["postId"] as String,
      userNickname: json["userNickname"] as String,
      userProfileImageUrl: json["userProfileImageUrl"] as String,
      content: json["content"] as String,
      // TODO : DateTime > TimeStamp 로 변환
      createdAt: json["createdAt"] is DateTime
          ? (json["createdAt"] as DateTime)
          : DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "postId": postId,
      "userNickname": userNickname,
      "userProfileImageUrl": userProfileImageUrl,
      "content": content,
      // TODO : DateTime > TimeStamp 로 변환
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
