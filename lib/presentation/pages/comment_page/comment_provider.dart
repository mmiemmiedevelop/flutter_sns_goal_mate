import 'package:flutter_princess/data/data_source/comment_data_source_impl.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/domain/usecase/fetch_comment_usecase.dart';
import 'package:flutter_princess/data/repository/comment_repository_impl.dart';

// Usecase Provider
final fetchCommentUsecaseProvider = Provider<FetchCommentUsecase>((ref) {
  final repo = CommentRepositoryImpl(
    CommentRemoteDataSourceImpl(FirebaseFirestore.instance),
  );
  return FetchCommentUsecase(repo);
});

// ViewModel Provider (postId별로 관리)
final commentProvider =
    NotifierProvider.family<CommentPageViewModel, CommentState, String>(
      CommentPageViewModel.new,
    );
