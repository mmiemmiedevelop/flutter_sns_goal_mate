// 비즈니스 로직 캡슐화 - 단일 책임 원칙 적용해야함 == 한가지 일만 해야함
// class FetchDUseCase {
//   final SampleRepository repository;
//
//   FetchDUseCase(this.repository);
//
//   Future<List<Movie>> execute() async {
//     return await repository.getNowPlayingMovies();
//   }
// }
