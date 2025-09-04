import 'dart:io';
import 'package:flutter_princess/domain/usecase/add_post_usecase.dart';
import 'package:flutter_princess/domain/usecase/upload_image_usecase.dart';
import 'package:flutter_princess/presentation/pages/home_page/home_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_princess/domain/entity/post.dart';

class WritePageState {
  // final File? selectedImage;
  final List<File> selectedImages;
  final bool isUploading;

  // WritePageState({this.selectedImage, this.isUploading = false});
  WritePageState({this.selectedImages = const [], this.isUploading = false});

  WritePageState copyWith({List<File>? selectedImages, bool? isUploading}) {
    return WritePageState(
      selectedImages: selectedImages ?? this.selectedImages,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class WritePageViewModel extends StateNotifier<WritePageState> {
  final UploadImagesUseCase _uploadImagesUseCase;
  final AddPostUseCase _addPostUseCase;
  final HomePageViewModel _homePageViewModel;

  WritePageViewModel(
    this._uploadImagesUseCase,
    this._addPostUseCase,
    this._homePageViewModel,
  ) : super(WritePageState());

  // 이미지 선택
  // void selectImage(File image) {
  void selectImages(List<File> images) {
    state = state.copyWith(
      selectedImages: [...state.selectedImages, ...images],
    );
  }

  // 이미지 삭제 기능
  void removeImage(int index) {
    final updatedImages = List<File>.from(state.selectedImages)
      ..removeAt(index);
    state = state.copyWith(selectedImages: updatedImages);
  }

  // 업로드 상태
  void setUploading(bool uploading) {
    state = state.copyWith(isUploading: uploading);
  }

  // 이미지 업로드
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    //여기다가 제가 준 코드
    // final imageUrls = await uploadImages(imageFiles: images, path: 'posts'); 하면 List<String> 반환됌
    //ㄴ 오키~

    return await _uploadImagesUseCase.execute(images, 'posts');
  }

  // 게시글 업로드
  Future<void> addPost(Post post) async {
    await _addPostUseCase.execute(post);

    _homePageViewModel.refresh();
  }
}
