import 'package:cloud_firestore/cloud_firestore.dart';

/// Post 데이터 소스에 대한 추상 클래스
/// DataSource가 어떤 기능들을 제공해야 하는지 정의해줌
abstract class PostDataSource {
  // 게시물 목록을 가져오는 기능
  Future<QuerySnapshot<Object?>> fetchPosts({DocumentSnapshot? lastDocument});
  // 좋아요 상태를 변경하는 기능
  Future<void> toggleLike(String postId, String userId);
  // 게시물을 삭제하는 기능
  Future<void> deletePost(String postId);
  //게시글 등록하는 기능
  //유저정보 uid
  //게시글 정보들 : tag,content,List<dynamic> imgurl, createdAt,
  Future<void> addPost(
    String uid,
    List<dynamic> tag,
    String content,
    List<dynamic> imgurl,
    DateTime? createdAt,
  );
}
