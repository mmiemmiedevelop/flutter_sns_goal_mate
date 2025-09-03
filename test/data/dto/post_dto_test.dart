// 파베 목파일 필요없는 케이스

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_princess/data/dto/post_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostDto', () {
    test("PostDto 직렬화/역직렬화 테스트", () {
      // given
      final timestamp = Timestamp.now();
      final postDto = PostDto(
        userId: 'test_user',
        userNickname: '테스트유저',
        userProfileImageUrl: 'http://example.com/profile.jpg',
        imageUrls: ['http://example.com/image1.jpg'],
        tags: ['#flutter', '#test'],
        content: '테스트 게시물 내용입니다.',
        createdAt: timestamp,
        likeCount: 10,
        commentCount: 5,
        likedBy: ['userA', 'userB'],
      );

      // when
      final json = postDto.toJson();
      final fromJson = PostDto.fromFirestore(json);

      // then
      expect(fromJson.userId, 'test_user');
      expect(fromJson.content, '테스트 게시물 내용입니다.');
      expect(fromJson.likeCount, 10);
      expect(fromJson.tags, containsAll(['#flutter', '#test']));
      expect(fromJson.createdAt, timestamp);
    });
  });
}
