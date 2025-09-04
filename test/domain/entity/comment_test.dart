// 파베 목파일 필요없는 케이스

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_princess/domain/entity/comment.dart';

void main() {
  group('Comment', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30, 45);

    final testComment = Comment(
      id: 'test_comment_id',
      userId: 'test_user_id',
      postId: 'test_post_id',
      userNickname: 'testUser',
      userProfileImageUrl: 'https://example.com/profile.jpg',
      content: '테스트 댓글 내용입니다',
      createdAt: testDateTime,
    );

    group('생성자 테스트', () {
      test('모든 필드가 올바르게 할당되어야 한다', () {
        // when
        final comment = Comment(
          id: 'comment123',
          userId: 'user456',
          postId: 'post789',
          userNickname: '닉네임',
          userProfileImageUrl: 'https://example.com/image.png',
          content: '댓글 내용',
          createdAt: testDateTime,
        );

        // then
        expect(comment.id, 'comment123');
        expect(comment.userId, 'user456');
        expect(comment.postId, 'post789');
        expect(comment.userNickname, '닉네임');
        expect(comment.userProfileImageUrl, 'https://example.com/image.png');
        expect(comment.content, '댓글 내용');
        expect(comment.createdAt, testDateTime);
      });
    });

    group('copyWith 메서드 테스트', () {
      test('id를 수정하면 id만 변경되고 나머지는 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(id: 'new_id');

        // then
        expect(copiedComment.id, 'new_id');
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test('userId를 수정하면 userId만 변경되고 나머지는 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(userId: 'new_user_id');

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, 'new_user_id');
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test('postId를 수정하면 postId만 변경되고 나머지는 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(postId: 'new_post_id');

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, 'new_post_id');
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test('userNickname을 수정하면 userNickname만 변경되고 나머지는 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(userNickname: '새로운닉네임');

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, '새로운닉네임');
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test(
        'userProfileImageUrl을 수정하면 userProfileImageUrl만 변경되고 나머지는 유지되어야 한다',
        () {
          // when
          final copiedComment = testComment.copyWith(
            userProfileImageUrl: 'https://new.example.com/profile.jpg',
          );

          // then
          expect(copiedComment.id, testComment.id);
          expect(copiedComment.userId, testComment.userId);
          expect(copiedComment.postId, testComment.postId);
          expect(copiedComment.userNickname, testComment.userNickname);
          expect(
            copiedComment.userProfileImageUrl,
            'https://new.example.com/profile.jpg',
          );
          expect(copiedComment.content, testComment.content);
          expect(copiedComment.createdAt, testComment.createdAt);
        },
      );

      test('content를 수정하면 content만 변경되고 나머지는 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(content: '수정된 댓글 내용');

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, '수정된 댓글 내용');
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test('createdAt을 수정하면 createdAt만 변경되고 나머지는 유지되어야 한다', () {
        // given
        final newDateTime = DateTime(2024, 12, 25, 15, 30, 0);

        // when
        final copiedComment = testComment.copyWith(createdAt: newDateTime);

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, newDateTime);
      });

      test('여러 필드를 동시에 수정할 수 있어야 한다', () {
        // given
        final newDateTime = DateTime(2024, 6, 1, 12, 0, 0);

        // when
        final copiedComment = testComment.copyWith(
          userNickname: '변경된닉네임',
          content: '변경된 댓글 내용',
          createdAt: newDateTime,
        );

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, '변경된닉네임');
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, '변경된 댓글 내용');
        expect(copiedComment.createdAt, newDateTime);
      });

      test('모든 필드를 null로 전달하면 기존 값이 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith(
          id: null,
          userId: null,
          postId: null,
          userNickname: null,
          userProfileImageUrl: null,
          content: null,
          createdAt: null,
        );

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });

      test('매개변수를 전달하지 않으면 기존 값이 유지되어야 한다', () {
        // when
        final copiedComment = testComment.copyWith();

        // then
        expect(copiedComment.id, testComment.id);
        expect(copiedComment.userId, testComment.userId);
        expect(copiedComment.postId, testComment.postId);
        expect(copiedComment.userNickname, testComment.userNickname);
        expect(
          copiedComment.userProfileImageUrl,
          testComment.userProfileImageUrl,
        );
        expect(copiedComment.content, testComment.content);
        expect(copiedComment.createdAt, testComment.createdAt);
      });
    });

    group('객체 비교 테스트', () {
      test('같은 값으로 생성된 두 Comment 객체는 각 필드가 같아야 한다', () {
        // given
        final comment1 = Comment(
          id: 'same_id',
          userId: 'same_user_id',
          postId: 'same_post_id',
          userNickname: 'same_nickname',
          userProfileImageUrl: 'same_url',
          content: 'same_content',
          createdAt: testDateTime,
        );

        final comment2 = Comment(
          id: 'same_id',
          userId: 'same_user_id',
          postId: 'same_post_id',
          userNickname: 'same_nickname',
          userProfileImageUrl: 'same_url',
          content: 'same_content',
          createdAt: testDateTime,
        );

        // then
        expect(comment1.id, comment2.id);
        expect(comment1.userId, comment2.userId);
        expect(comment1.postId, comment2.postId);
        expect(comment1.userNickname, comment2.userNickname);
        expect(comment1.userProfileImageUrl, comment2.userProfileImageUrl);
        expect(comment1.content, comment2.content);
        expect(comment1.createdAt, comment2.createdAt);
      });

      test('다른 값으로 생성된 Comment 객체는 다른 필드를 가져야 한다', () {
        // given
        final comment1 = testComment;
        final comment2 = Comment(
          id: 'different_id',
          userId: 'different_user_id',
          postId: 'different_post_id',
          userNickname: 'different_nickname',
          userProfileImageUrl: 'different_url',
          content: 'different_content',
          createdAt: DateTime(2024, 2, 1, 9, 0, 0),
        );

        // then
        expect(comment1.id, isNot(comment2.id));
        expect(comment1.userId, isNot(comment2.userId));
        expect(comment1.postId, isNot(comment2.postId));
        expect(comment1.userNickname, isNot(comment2.userNickname));
        expect(
          comment1.userProfileImageUrl,
          isNot(comment2.userProfileImageUrl),
        );
        expect(comment1.content, isNot(comment2.content));
        expect(comment1.createdAt, isNot(comment2.createdAt));
      });
    });

    group('경계값 테스트', () {
      test('빈 문자열로 Comment를 생성할 수 있어야 한다', () {
        // when
        final comment = Comment(
          id: '',
          userId: '',
          postId: '',
          userNickname: '',
          userProfileImageUrl: '',
          content: '',
          createdAt: testDateTime,
        );

        // then
        expect(comment.id, '');
        expect(comment.userId, '');
        expect(comment.postId, '');
        expect(comment.userNickname, '');
        expect(comment.userProfileImageUrl, '');
        expect(comment.content, '');
        expect(comment.createdAt, testDateTime);
      });

      test('매우 긴 문자열로 Comment를 생성할 수 있어야 한다', () {
        // given
        final longString = 'a' * 1000;

        // when
        final comment = Comment(
          id: longString,
          userId: longString,
          postId: longString,
          userNickname: longString,
          userProfileImageUrl: longString,
          content: longString,
          createdAt: testDateTime,
        );

        // then
        expect(comment.id, longString);
        expect(comment.userId, longString);
        expect(comment.postId, longString);
        expect(comment.userNickname, longString);
        expect(comment.userProfileImageUrl, longString);
        expect(comment.content, longString);
        expect(comment.createdAt, testDateTime);
      });

      test('특수 문자가 포함된 문자열로 Comment를 생성할 수 있어야 한다', () {
        // given
        const specialChars = '!@#\$%^&*()_+-=[]{}|;\':",./<>?`~';

        // when
        final comment = Comment(
          id: specialChars,
          userId: specialChars,
          postId: specialChars,
          userNickname: specialChars,
          userProfileImageUrl: specialChars,
          content: specialChars,
          createdAt: testDateTime,
        );

        // then
        expect(comment.id, specialChars);
        expect(comment.userId, specialChars);
        expect(comment.postId, specialChars);
        expect(comment.userNickname, specialChars);
        expect(comment.userProfileImageUrl, specialChars);
        expect(comment.content, specialChars);
        expect(comment.createdAt, testDateTime);
      });

      test('유니코드 문자(한글, 이모지)로 Comment를 생성할 수 있어야 한다', () {
        // given
        const unicode = '안녕하세요! 😊🎉 这是测试 こんにちは';

        // when
        final comment = Comment(
          id: unicode,
          userId: unicode,
          postId: unicode,
          userNickname: unicode,
          userProfileImageUrl: unicode,
          content: unicode,
          createdAt: testDateTime,
        );

        // then
        expect(comment.id, unicode);
        expect(comment.userId, unicode);
        expect(comment.postId, unicode);
        expect(comment.userNickname, unicode);
        expect(comment.userProfileImageUrl, unicode);
        expect(comment.content, unicode);
        expect(comment.createdAt, testDateTime);
      });
    });
  });
}
