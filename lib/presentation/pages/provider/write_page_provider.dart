import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_princess/data/repository/storage_repository_impl.dart';
import 'package:flutter_princess/domain/usecase/add_post_usecase.dart';
import 'package:flutter_princess/domain/usecase/upload_images_usecase.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_princess/presentation/pages/provider/home_provider.dart';
import 'package:flutter_princess/presentation/pages/write_page/write_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Storage
final storageProvider = Provider((ref) => FirebaseStorage.instance);
final storageRepositoryProvider = Provider(
  (ref) => StorageRepositoryImpl(ref.watch(storageProvider)),
);

// UseCases
final uploadImagesUseCaseProvider = Provider(
  (ref) => UploadImagesUseCase(ref.watch(storageRepositoryProvider)),
);
final addPostUseCaseProvider = Provider(
  (ref) => AddPostUseCase(ref.watch(postRepositoryProvider)),
);

final writePageViewModelProvider =
    StateNotifierProvider<WritePageViewModel, WritePageState>(
      (ref) => WritePageViewModel(
        ref.read(uploadImagesUseCaseProvider),
        ref.read(addPostUseCaseProvider),
        ref.read(homePageViewModelProvider.notifier),
      ),
    );
