import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/data_source/add_post_data_source.dart';

class AddPostDataSourceImpl implements AddPostDataSource {
  final _db = FirebaseFirestore.instance;
}
