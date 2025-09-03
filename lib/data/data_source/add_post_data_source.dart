abstract interface class AddPostDataSource {
  //게시글 등록하는 기능
  //유저정보 uid
  //게시글 정보들 : tag,content,List<dynamic> imgurl, createdAt,
  Future<void> addPost(
    String uid,
    List<String> tag,
    String content,
    List<String> imgurl,
    DateTime? createdAt,
  );
}
