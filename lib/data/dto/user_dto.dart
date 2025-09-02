import 'package:cloud_firestore/cloud_firestore.dart';

class UserDto {
  final String uid;
  final String email;
  final String userNickName;
  final String profileImgUrl;

  UserDto({
    required this.uid,
    required this.email,
    required this.userNickName,
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
      userNickName: data['userNickName'] as String,
      profileImgUrl: data['profileImgUrl'] as String,
    );
  }

  //Dto -> firebase
  Map<String, dynamic> toFireStore() => {
    'uid': uid,
    'email': email,
    'userNickName': userNickName,
    'profileImgUrl': profileImgUrl,
  };
}
