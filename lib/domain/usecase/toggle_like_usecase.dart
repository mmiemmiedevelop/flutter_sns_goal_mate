import 'package:flutter_princess/domain/repository/post_repository.dart';

// 좋아요 상태 변경하기
class ToggleLikeUseCase {
  final PostRepository _repository;
  ToggleLikeUseCase(this._repository);

  Future<void> execute(String postId, String userId) {
    return _repository.toggleLike(postId, userId);
  }
}
