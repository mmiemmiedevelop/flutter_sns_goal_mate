import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';

// 게시글 목록 가져오기
class FetchPostsUseCase {
  final PostRepository _repository;
  FetchPostsUseCase(this._repository);

  Future<List<Post>> execute() {
    return _repository.fetchPosts();
  }
}
