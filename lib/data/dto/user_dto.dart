import 'package:cloud_firestore/cloud_firestore.dart';

class UserDto {
  final String uid;
  final String id;
  final String userNickName;
  final String? profileImgUrl;
  final DateTime createdAt;
  UserDto({
    required this.uid,
    required this.id,
    required this.userNickName,
    required this.profileImgUrl,
    required this.createdAt,
  });

  //fireStoreDto
  //firebase ->Dto
  factory UserDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserDto(
      uid: data['uid'],
      id: data['id'], //이메일
      userNickName: data['userNickName'],
      profileImgUrl: data['profileImgUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }


  //Dto -> firebase
  Map<String, dynamic> toFireStore() => {
    'uid': uid,
    'id': id,
    'userNickName': userNickName,
    'profileImgUrl': profileImgUrl,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  //Map<String, dynamic> 형태의 json 데이터를 받아서 MovieDto 인스턴스로 만드는 네임드 생성자
  UserDto.fromJson(Map<String, dynamic> map)
    : this(
        uid: map['uid'],
        id: map['id'],
        userNickName: map['userNickName'],
        profileImgUrl: map['profileImgUrl'],
        createdAt: map['createAt'],
      );

  //객체를 json으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'userNickName': userNickName,
      'profileImgUrl': profileImgUrl,
      'createAt': createdAt,
    };
  }
}
