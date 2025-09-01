// 댓글 페이지
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  // final Stirng postID;
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  // 댓글 텍스트 컨트롤러
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _inputText = "";

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        _inputText = _commentController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
    _focusNode.dispose();
  }

  // 댓글 전송 로직
  void _sentComment() {
    if (_inputText.trim().isEmpty) return;

    setState(() {
      // 전송 시 화면 즉시 반영 혹은 새로고침
      // comments.insert(0, newComment);
    });

    // TODO: 파이어베이스 저장

    _commentController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("댓글 4"), centerTitle: true),
      body:
          // 파이어베이스 완료 후 RefreshIndicator 추가
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          // backgroundImage: NetworkImage(comment["imageUri"]),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "formatTime(commentTime)",
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
                          child: Text("comment[\"content\"]!"),
                        ),

                        // 더보기(수정, 삭제)
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return vertButton(context);
                                // return vertButton(context, comment[index]);
                              },
                            );
                          },
                          icon: Icon(Icons.more_vert),
                        ),
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
                _commentInput(),
              ],
            ),
          ),
    );
  }

  // 더보기 팝업창
  Widget vertButton(BuildContext context) {
    // Widget vertButton(BuildContext context, Map<String, dynamic> comment) {
    return AlertDialog(
      title: const Text("팝업(게시물 팝업이랑 공통 디자인)"),
      content: const Text("댓글을 수정하거나 삭제하시겠습니까?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // _editComment(comment["id"], comment["content"]);
          },
          child: const Text("수정"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // _deleteComment(comment["id"]);
          },
          child: const Text("삭제"),
        ),
      ],
    );
  }

  // 댓글 수정
  void _editComment(String id, String currentContent) {
    final TextEditingController editController = TextEditingController(
      text: currentContent,
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
                Navigator.of(context).pop(); // 취소
              },
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // final index = comments.indexWhere(
                  //   (comment) => comment["id"] == id,
                  // );
                  // if (index != -1) {
                  //   comments[index]["content"] = editController.text;
                  // }
                });

                // TODO: Firebase에도 반영
                // FirebaseFirestore.instance.collection("comments").doc(id).update({"content": editController.text});

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
  void _deleteComment(String id) {
    setState(() {
      // TODO: FIrebase에서도 삭제
      // comments.removeWhere((comment) => comment["id"] == id);
    });
  }

  // 댓글 입력
  Widget _commentInput() {
    final isActive = _inputText.trim().isNotEmpty;
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
              backgroundColor: Colors.amber,
              // backgroundImage: NetworkImage(""),
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
                  setState(() {
                    _inputText = value;
                  });
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
              "${_inputText.length}/500",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            ),

            // 전송 버튼
            IconButton(
              onPressed: () {
                isActive ? _sentComment : null;
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

  // 작성시간 포매터
  formatTime(DateTime datetime) {
    final now = DateTime.now();
    final difference = now.difference(datetime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}분 전";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}시간 전";
    } else {
      return DateFormat("yyyy-MM-dd").format(datetime);
    }
  }
}
