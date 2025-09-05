import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_princess/domain/repository/storage_repository.dart';
import 'package:logger/web.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<List<String>> uploadImages(List<File> images, String path) async {
    final logger = Logger();
    final futures = images.asMap().entries.map((entry) async {
      final index = entry.key;
      final imageFile = entry.value;

      final fileName =
          '${index}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = _storage.ref('$path/$fileName');

      //이미지압축 시작
      logger.d(ref);
      final compressed = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 70, // 0~100 (낮을수록 용량↓, 화질↓)
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        throw Exception("이미지 압축 실패");
      } else {
        logger.d('이미지압축완료 $compressed');
      }
      //이미지압축 끝
      final bytes = await imageFile.readAsBytes();
      final uploadTask = await ref.putData(compressed);

      return await uploadTask.ref.getDownloadURL();
    }).toList();

    return await Future.wait(futures);
  }
}
