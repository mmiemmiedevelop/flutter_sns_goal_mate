import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_remote_data_source_impl.dart';
import 'package:flutter_princess/data/repository/post_repository_impl.dart';
import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';
import 'package:flutter_princess/domain/usecase/delete_post_usecase.dart';
import 'package:flutter_princess/domain/usecase/fetch_posts_usecase.dart';
import 'package:flutter_princess/domain/usecase/toggle_like_usecase.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Data layer providers ---
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// DataSource 인터페이스와 구현체를 분리하여 provider로 제공
final postDataSourceProvider = Provider(
  (ref) => PostRemoteDataSourceImpl(ref.watch(firestoreProvider)),
);

// --- Domain layer providers ---
final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepositoryImpl(ref.watch(postDataSourceProvider)),
);

// --- UseCase들을 각각 provider로 만들어서 viewmodel이 사용하기 쉽도록 ---
final fetchPostsUseCaseProvider = Provider(
  (ref) => FetchPostsUseCase(ref.watch(postRepositoryProvider)),
);

final toggleLikeUseCaseProvider = Provider(
  (ref) => ToggleLikeUseCase(ref.watch(postRepositoryProvider)),
);

final deletePostUseCaseProvider = Provider(
  (ref) => DeletePostUseCase(ref.watch(postRepositoryProvider)),
);

final homePageViewModelProvider =
    StateNotifierProvider<HomePageViewModel, List<Post>>((ref) {
      return HomePageViewModel(
        ref.watch(fetchPostsUseCaseProvider),
        ref.watch(toggleLikeUseCaseProvider),
        ref.watch(deletePostUseCaseProvider),
      );
    });
