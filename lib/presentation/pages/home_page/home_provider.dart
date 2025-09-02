import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/post_data_source.dart';
import 'package:flutter_princess/data/repository/post_repository_impl.dart';
import 'package:flutter_princess/domain/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final postDataSourceProvider = Provider(
  (ref) => PostDataSource(ref.watch(firestoreProvider)),
);

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepositoryImpl(ref.watch(postDataSourceProvider)),
);
