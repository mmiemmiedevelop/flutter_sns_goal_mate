// 파베 목파일 필요없는 케이스

import 'package:flutter_princess/data/dto/comment_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("CommentDto 직렬화/역직렬화 테스트", () {
    // given
    final now = DateTime.now();
    final dto = CommentDto(
      id: "1",
      userId: "user123",
      postId: "post456",
      userNickname: "ym",
      userProfileImageUrl: "https://i.pravatar.cc/100",
      content: "테스트 댓글",
      createdAt: now,
    );

    // when
    final json = dto.toJson();
    final fromJson = CommentDto.fromJson(json);

    // then
    expect(fromJson.userId, "user123");
    expect(fromJson.content, "테스트 댓글");
    expect(fromJson.createdAt.toIso8601String(), now.toIso8601String());
  });
}
