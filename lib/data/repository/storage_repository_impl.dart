import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_princess/domain/repository/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<List<String>> uploadImages(List<File> images, String path) async {
    final futures = images.asMap().entries.map((entry) async {
      final index = entry.key;
      final imageFile = entry.value;

      final fileName =
          '${index}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = _storage.ref('$path/$fileName');

      final bytes = await imageFile.readAsBytes();
      final uploadTask = await ref.putData(bytes);

      return await uploadTask.ref.getDownloadURL();
    }).toList();

    return await Future.wait(futures);
  }
}
