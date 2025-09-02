class User {
  final String uid;
  final String email;
  final String userNickname;
  final String? profileImgUrl;
  User({
    required this.uid,
    required this.email,
    required this.userNickname,
    required this.profileImgUrl,
  });
  // 닉네임,프로필이미지변경(예정)
  User copyWith({
    String? uid,
    String? email,
    String? userNickname,
    String? profileImgUrl,
  }) {
    return User(
      uid: this.uid,
      email: this.email,
      userNickname: userNickname ?? this.userNickname,
      profileImgUrl: profileImgUrl ?? this.profileImgUrl,
    );
  }

  String toString() =>
      'User(uid: $uid, email: $email, nick: $userNickname, profile: $profileImgUrl)';
}
