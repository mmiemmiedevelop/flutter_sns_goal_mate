class User {
  final String uid;
  final String id;
  final String userNickName;
  final String? profileImgUrl;
  final DateTime createdAt;
  User({
    required this.uid,
    required this.id,
    required this.userNickName,
    required this.profileImgUrl,
    required this.createdAt,
  });
  // 닉네임,프로필이미지변경(예정)
  User copyWith({
    String? id,
    String? userId,
    String? postId,
    String? userNickname,
    String? userProfileImageUrl,
    String? content,
    DateTime? createdAt,
  }) {
    return User(
      uid: this.uid,
      id: this.id,
      userNickName: userNickName ?? this.userNickName,
      profileImgUrl: profileImgUrl ?? this.profileImgUrl,
      createdAt: this.createdAt,
    );
  }
}
