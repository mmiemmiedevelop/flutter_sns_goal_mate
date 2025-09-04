import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';

class AddPostUseCase {
  final PostRepository _repository;
  AddPostUseCase(this._repository);

  Future<void> execute(Post post) {
    return _repository.addPost(post);
  }
}
