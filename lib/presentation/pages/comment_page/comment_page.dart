// 댓글 페이지
import 'package:flutter/material.dart';
import 'package:flutter_princess/domain/entity/comment.dart';
import 'package:flutter_princess/presentation/common_widget/util/formatters.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_page_view_model.dart';
import 'package:flutter_princess/presentation/pages/comment_page/comment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentPage extends ConsumerStatefulWidget {
  final String postId;
  // 접속중인 유저 정보 필요
  // ex) User user or String userID, userNickName etc.
  final String userId;
  final String userNickname;
  final String userProfileImageUrl;

  const CommentPage({
    super.key,
    required this.postId,
    required this.userId,
    required this.userNickname,
    required this.userProfileImageUrl,
  });

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  // 댓글 텍스트 컨트롤러
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late CommentPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      ref
          .read(commentProvider(widget.postId).notifier)
          .sentInputText(_commentController.text);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 댓글 전송 로직
  void _sentComment() {
    final vm = ref.read(commentProvider(widget.postId).notifier);

    if (_commentController.text.trim().isEmpty) return;

    vm.sentComment(
      widget.userId,
      widget.postId,
      widget.userNickname,
      widget.userProfileImageUrl,
    );

    _commentController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commentProvider(widget.postId));
    final vm = ref.read(commentProvider(widget.postId).notifier);
    return state.when(
      data: (data) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("댓글 ${data.comments.length}"),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await vm.fetchComments(widget.postId);
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: const Color.fromARGB(105, 158, 158, 158),
                ),

                Expanded(
                  child: ListView.separated(
                    itemCount: data.comments.length,
                    itemBuilder: (context, index) {
                      final comment = data.comments[index];

                      // id 비교
                      final isMine = comment.userId == widget.userId;

                      return ListTile(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return popup(context, comment);
                            },
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            comment.userProfileImageUrl,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.userNickname,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatTimestamp(comment.createdAt),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        // 내용
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(comment.content),
                        ),

                        // 더보기(수정, 삭제)
                        trailing:
                            // isMine ?
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    // return vertButton(context, comment);
                                    return popup(context, comment);
                                  },
                                );
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                        // : null,
                      );
                    },

                    // Divider
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 5),
                          Divider(height: 1),
                          SizedBox(height: 5),
                        ],
                      );
                    },
                  ),
                ),
                Divider(height: 1),

                // 댓글 입력
                _commentInput(),
              ],
            ),
          ),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("에러 발생 : $err")),
    );
  }

  // 더보기 팝업창
  Widget popup(BuildContext context, Comment comment) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          ListTile(
            title: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(134, 96, 62, 234),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: const Text(
                  "수정하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _editComment(comment);
            },
          ),
          ListTile(
            title: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF613EEA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: const Text(
                  "삭제하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _deleteComment(comment);
            },
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }

  // 댓글 수정
  void _editComment(Comment comment) {
    final TextEditingController editController = TextEditingController(
      text: comment.content,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("댓글 수정"),
          content: TextField(
            controller: editController,
            maxLength: 500,
            decoration: InputDecoration(hintText: "댓글을 입력하세요", counterText: ""),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                final vm = ref.read(commentProvider(widget.postId).notifier);
                vm.editComment(comment.id, editController.text);
                Navigator.of(context).pop();
              },
              child: Text("수정"),
            ),
          ],
        );
      },
    );
  }

  // 댓글 삭제
  void _deleteComment(Comment comment) {
    final vm = ref.read(commentProvider(widget.postId).notifier);
    vm.deleteComment(comment.id);
  }

  // 댓글 입력
  Widget _commentInput() {
    final vm = ref.read(commentProvider(widget.postId).notifier);
    final isActive = _commentController.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            SizedBox(width: 4),
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.userProfileImageUrl),
            ),
            SizedBox(width: 8),

            // 댓글 입력창
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _focusNode,
                maxLength: 500,
                maxLines: isActive ? 2 : 1,
                onChanged: (value) {
                  vm.sentInputText(value);
                },
                decoration: InputDecoration(
                  hintText: "댓글을 입력하세요",
                  border: InputBorder.none,
                  counterText: "",
                ),
              ),
            ),

            // 남은 글자 수
            Text(
              "${_commentController.text.length}/500",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            ),

            // 전송 버튼
            IconButton(
              onPressed: () {
                if (isActive) {
                  isActive ? _sentComment() : null;
                }
              },
              icon: Icon(
                Icons.send,
                color: isActive ? Colors.deepPurple : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
