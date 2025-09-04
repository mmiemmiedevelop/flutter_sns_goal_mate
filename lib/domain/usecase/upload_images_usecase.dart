import 'dart:io';
import 'package:flutter_princess/domain/repository/storage_repository.dart';

class UploadImagesUseCase {
  final StorageRepository _repository;
  UploadImagesUseCase(this._repository);

  Future<List<String>> execute(List<File> images, String path) async {
    return await _repository.uploadImages(images, path);
  }
}
