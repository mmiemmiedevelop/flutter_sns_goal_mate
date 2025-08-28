// 4. 샘플 리포지토리 : 도메인 계층과 인터페이스 구현
// import 'package:flutter_princess/data/data_source/s_data_source.dart';
// import 'package:flutter_princess/data/dto/s_dto.dart';
//
// class SampleRepositoryImpl extends SampleRepository {
//   final SampleDataSource dataSource;
//
//   SampleRepositoryImpl(this.dataSource);
//
//   @override
//   Future<List<Movie>> getNowPlayingMovies() async {
//     final movieDTOs = await dataSource.getNowPlayingMovies();
//     return movieDTOs.map((dto) => Movie.fromDTO(dto)).toList();
//   }
// }
