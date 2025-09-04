import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';

// 게시글 목록 가져오기
class FetchPostsUseCase {
  FetchPostsUseCase(this._repository);
  final PostRepository _repository;

  Future<List<Post>> execute({bool reset = false}) {
    if (reset) _repository.reset();

    return _repository.fetchPosts();
  }

  // repositoy의 reset 여기서 호출
  void reset() {
    _repository.reset();
  }
}
