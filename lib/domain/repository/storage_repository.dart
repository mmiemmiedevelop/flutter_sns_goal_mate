import 'dart:io';

abstract class StorageRepository {
  Future<List<String>> uploadImages(List<File> images, String path);
}
