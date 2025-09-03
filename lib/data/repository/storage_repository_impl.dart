import 'dart:io';

import 'package:flutter_princess/domain/repository/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl(this._storage);

  final FirebaseStorage _storage;



  @override
  Future<String> uploadImage(File image, String path) {
    final ref = _storage.ref()
  }


 
 
//   final ref = FirebaseStorage.instance.ref('users/${user.uid}/profile.jpg');
//       final imgbyte = await imgUrl!.readAsBytes();
//       final putData = await ref.putData(imgbyte);
//       final String profileImgUrl = await putData.ref.getDownloadURL();


}
