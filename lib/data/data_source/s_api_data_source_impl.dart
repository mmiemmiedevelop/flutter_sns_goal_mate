// 1. 외부 API 데이터 소스 구현
// import 'package:http/http.dart' as http;

// class ApiSampleDataSource extends SampleDataSource {
//   final http.Client client;

//   ApiSampleDataSource(this.client);

//   @override
//   Future<List<Movie>> getNowPlayingMovies() async {
//     final response = await client.get(Uri.parse(ApiConfig.nowPlaying));

//     if (response.statusCode == 200) {
//       // JSON 파싱 및 Movie 객체 리스트 반환
//     } else {
//       throw Exception('Failed to load now playing movies');
//     }
//   }
// }
