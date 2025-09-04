// 파베 목파일 필요없는 케이스

import 'package:flutter_princess/domain/entity/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post Entity', () {
    final now = DateTime.now();
    final basePost = Post(
      id: 'post1',
      userId: 'user1',
      userNickname: '유저1',
      userProfileImageUrl: 'url',
      imageUrls: [],
      tags: [],
      content: '내용',
      createdAt: now,
      likeCount: 5,
      commentCount: 2,
      likedBy: ['user2', 'user3'],
    );

    group('copyWith 메서드 테스트', () {
      test('likeCount를 수정하면 해당 필드만 변경되어야 한다', () {
        // when
        final updatedPost = basePost.copyWith(likeCount: 10);

        // then
        expect(updatedPost.id, basePost.id);
        expect(updatedPost.likeCount, 10);
        expect(updatedPost.likedBy, basePost.likedBy);
      });
    });

    group('toggleLike 메서드 테스트', () {
      test('좋아요를 누르지 않은 유저가 좋아요를 누른다', () {
        // when
        final updatedPost = basePost.toggleLike('newUser');

        // then
        expect(updatedPost.likeCount, basePost.likeCount + 1);
        expect(updatedPost.likedBy, contains('newUser'));
      });

      test('이미 좋아요를 누른 유저가 좋아요를 취소한다', () {
        // when
        final updatedPost = basePost.toggleLike('user2');

        // then
        expect(updatedPost.likeCount, basePost.likeCount - 1);
        expect(updatedPost.likedBy, isNot(contains('user2')));
      });
    });
  });
}
