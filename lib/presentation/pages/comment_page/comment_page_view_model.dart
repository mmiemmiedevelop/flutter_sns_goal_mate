// 댓글 페이지 뷰 모델

import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/domain/usecase/fetch_comment_usecase.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_provider.dart';
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

class CommentPageViewModel extends FamilyNotifier<CommentState, String> {
  final _uuid = Uuid();

  @override
  CommentState build(String postId) {
    fetchComments(postId);
    return CommentState();
  }

  FetchCommentUsecase get _usecase => ref.read(fetchCommentUsecaseProvider);

  // 댓글 불러오기
  Future<void> fetchComments(postId) async {
    state = state.copyWith(isLoading: true);
    try {
      final comments = await _usecase.fetchComments(postId);
      state = state.copyWith(comments: comments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // 댓글 등록하기
  void sentInputText(String value) {
    state = state.copyWith(inputText: value);
  }

  Future<void> sentComment(
    String userId,
    String postId,
    String userNickname,
    String userProfileImageUrl,
  ) async {
    if (state.inputText.trim().isEmpty) true;

    final newComment = Comment(
      id: _uuid.v4(),
      userId: userId,
      postId: arg,
      userNickname: userNickname,
      userProfileImageUrl: userProfileImageUrl,
      content: state.inputText,
      createdAt: DateTime.now(),
    );

    try {
      await _usecase.addComment(newComment);
      state = state.copyWith(
        comments: [newComment, ...state.comments],
        inputText: "",
      );
    } catch (_) {}
  }

  // 댓글 수정하기
  Future<void> editComment(String id, String newComment) async {
    final index = state.comments.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final updated = state.comments[index].copyWith(content: newComment);
    try {
      await _usecase.updateComment(updated);
      final updatedList = [...state.comments];
      updatedList[index] = updated;
      state = state.copyWith(comments: updatedList);
    } catch (_) {}
  }

  // 댓글 삭제하기
  Future<void> deleteComment(String id) async {
    try {
      await _usecase.deleteComment(id);
      state = state.copyWith(
        comments: state.comments.where((c) => c.id != id).toList(),
      );
    } catch (_) {}
  }
}

final commentProvider =
    NotifierProvider.family<CommentPageViewModel, CommentState, String>(
      CommentPageViewModel.new,
    );
