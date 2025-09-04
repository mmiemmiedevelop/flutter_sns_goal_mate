// 댓글 페이지 뷰 모델

import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/usecase/fetch_comment_usecase.dart';
import 'package:flutter_princess/presentation/pages/provider/comment_provider.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CommentState {
  final List<Comment> comments;
  final bool isLoading;
  final String inputText;

  CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.inputText = "",
  });

  CommentState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    String? inputText,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      inputText: inputText ?? this.inputText,
    );
  }
}

class CommentPageViewModel extends FamilyAsyncNotifier<CommentState, String> {
  final _uuid = Uuid();

  FetchCommentUsecase get _usecase => ref.read(fetchCommentUsecaseProvider);

  @override
  Future<CommentState> build(String postId) async {
    final comments = await fetchComments(postId);
    return CommentState(comments: comments, isLoading: false);
  }

  Future<List<Comment>> fetchComments(String postId) async {
    return await _usecase.fetchComments(postId);
  }

  // 댓글 등록하기
  Future<void> sentComment(
    String userId,
    String postId,
    String userNickname,
    String userProfileImageUrl,
  ) async {
    final stateNow = state.valueOrNull;
    if (stateNow == null || stateNow.inputText.trim().isEmpty) return;

    final newComment = Comment(
      id: _uuid.v4(),
      userId: userId,
      postId: arg,
      userNickname: userNickname,
      userProfileImageUrl: userProfileImageUrl,
      content: stateNow.inputText,
      createdAt: DateTime.now(),
    );

    try {
      // Firebase에 댓글 추가 (동시에 포스트의 댓글 수도 증가)
      await _usecase.addComment(newComment);

      // 로컬 상태 업데이트
      final newComments = [newComment, ...stateNow.comments];
      state = AsyncData(
        stateNow.copyWith(comments: newComments, inputText: ""),
      );

      // 홈페이지에서 Firebase로부터 최신 포스트 데이터를 가져와서 업데이트
      await ref
          .read(homePageViewModelProvider.notifier)
          .refreshPostCommentCount(arg);
    } catch (e) {
      print("Error adding comment: $e");
    }
  }

  void sentInputText(String value) {
    final stateNow = state.valueOrNull ?? CommentState();
    state = AsyncData(stateNow.copyWith(inputText: value));
  }

  // 댓글 수정하기
  Future<void> editComment(String id, String newContent) async {
    final stateNow = state.valueOrNull;
    if (stateNow == null) return;

    final index = stateNow.comments.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final updated = stateNow.comments[index].copyWith(content: newContent);

    try {
      await _usecase.updateComment(updated);
      final updatedList = [...stateNow.comments];
      updatedList[index] = updated;
      state = AsyncData(stateNow.copyWith(comments: updatedList));
    } catch (_) {}
  }

  // 댓글 삭제하기
  Future<void> deleteComment(String id) async {
    final stateNow = state.valueOrNull;
    if (stateNow == null) return;

    try {
      // Firebase에서 댓글 삭제 (동시에 포스트의 댓글 수도 감소)
      await _usecase.deleteComment(id);

      // 로컬 상태 업데이트
      final newComments = stateNow.comments.where((c) => c.id != id).toList();
      state = AsyncData(stateNow.copyWith(comments: newComments));

      // 홈페이지에서 Firebase로부터 최신 포스트 데이터를 가져와서 업데이트
      await ref
          .read(homePageViewModelProvider.notifier)
          .refreshPostCommentCount(arg);
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }
}
