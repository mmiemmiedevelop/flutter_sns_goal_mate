import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entity/post.dart';
import '../../../domain/repository/write_repository.dart';
import '../home_page/home_page_view_model.dart';

final writePageViewModelProvider =
    StateNotifierProvider<WritePageViewModel, WritePageState>(
      (ref) => WritePageViewModel(ref),
    );

class WritePageState {
  final File? selectedImage;
  final bool isUploading;

  WritePageState({this.selectedImage, this.isUploading = false});

  WritePageState copyWith({File? selectedImage, bool? isUploading}) {
    return WritePageState(
      selectedImage: selectedImage ?? this.selectedImage,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class WritePageViewModel extends StateNotifier<WritePageState> {
  final Ref ref;
  final WriteRepository _repository = WriteRepository();

  WritePageViewModel(this.ref) : super(WritePageState());

  void selectImage(File image) {
    state = state.copyWith(selectedImage: image);
  }

  Future<String?> uploadImage(File image) async {
    return await _repository.uploadImage(image);
  }

  Future<void> addPost(Post post) async {
    ref.read(homePageViewModelProvider.notifier).fetchNextPage();
  }

  void setUploading(bool value) {
    state = state.copyWith(isUploading: value);
  }
}
