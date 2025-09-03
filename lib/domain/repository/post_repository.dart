import 'package:flutter_princess/domain/entity/post.dart';

// 공주의 규칙 1.- 4.
abstract class PostRepository {
  // 1. 게시글 리스트를 가져오거라. 성공하면 Post list, 실패하면 에러 던짐
  Future<List<Post>> fetchPosts();
  // 2. 좋아요 상태를 변경하거라.
  Future<void> toggleLike(String postId, String usertId);
  // 3. 게시글을 삭제하거라.
  Future<void> deletePost(String postId);
  // 4. 게시글을 추가하거라.
  Future<void> addPost(Post post);
}
