import 'package:cloud_firestore/cloud_firestore.dart';

class UserDto {
  final String uid;
  final String email;
  final String userNickname;
  final String profileImgUrl;

  UserDto({
    required this.uid,
    required this.email,
    required this.userNickname,
    required this.profileImgUrl,
  });

  //fireStoreDto
  //firebase ->Dto
  factory UserDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('${doc.id} has no data');
    }
    return UserDto(
      uid: data['uid'] as String,
      email: data['email'] as String,
      userNickname: data['userNickname'] as String,
      profileImgUrl: data['profileImgUrl'] as String,
    );
  }

  //Dto -> firebase
  Map<String, dynamic> toFireStore() => {
    'uid': uid,
    'email': email,
    'userNickname': userNickname,
    'profileImgUrl': profileImgUrl,
  };
}
