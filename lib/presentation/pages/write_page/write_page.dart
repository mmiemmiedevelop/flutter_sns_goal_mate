import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/common_widget/theme/theme.dart';
import 'package:flutter_princess/presentation/pages/provider/write_page_provider.dart';
import 'package:flutter_princess/presentation/pages/user_view_model/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'write_page_view_model.dart';
import '../../../domain/entity/post.dart';

class WritePage extends ConsumerStatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int _maxCharacters = 100;
  int _currentCharacters = 0;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateCharacterCount);
  }

  void _updateCharacterCount() {
    setState(() {
      _currentCharacters = _contentController.text.length;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isEmpty) return;

      final files = images.map((image) => File(image.path)).toList();

      ref.read(writePageViewModelProvider.notifier).selectImages(files);
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  Future<bool> _showExitDialog() async {
    final selectedImages = ref.read(writePageViewModelProvider).selectedImages;
    if (selectedImages.isNotEmpty ||
        _tagController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
      return (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text('나가시면 작성하신 게 지워져요'),
              actions: [
                TextButton(
                  onPressed: () => context.pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => context.pop(true),
                  child: const Text('나가기'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  Widget _buildImagePreview() {
    final state = ref.watch(writePageViewModelProvider);
    final vm = ref.read(writePageViewModelProvider.notifier);

    //이미지 선택 안했을 때
    if (state.selectedImages.isEmpty) {
      return GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            color: GoalMateTheme.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
          ),
        ),
      );
    }
    // 이미지 선택 됐을 때 PageView
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: GoalMateTheme.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: PageView.builder(
        itemCount: state.selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  state.selectedImages[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: GoalMateTheme.black,
                      size: 20,
                    ),
                    onPressed: () => vm.removeImage(index),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writePageViewModelProvider);
    final vm = ref.read(writePageViewModelProvider.notifier);
    final userState = ref.watch(userStateViewmodelProvider);
    if (userState == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            if (await _showExitDialog()) context.pop();
          },
        ),
        title: const Text(
          '게시글 작성',
          style: TextStyle(color: Color(0xFF322626), fontSize: 20),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0, color: const Color(0xFFE5E5EA)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            _buildImagePreview(),
            if (state.selectedImages.isNotEmpty)
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.add_a_photo),
                label: Text("사진 추가"),
              ),
            const SizedBox(height: 30),
            TextField(
              controller: _tagController,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                hintText: '#태그1 #태그2 #태그3',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              maxLength: _maxCharacters,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                hintText: 'ex) 버스 타고 가는 길을 운동 삼아 20분 일찍 일어나 걸어왔어요!',
                hintStyle: TextStyle(color: Colors.grey[600]),
                counterText: '($_currentCharacters/$_maxCharacters)',
                counterStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isUploading
                  ? null
                  : () async {
                      if (_contentController.text.isEmpty ||
                          state.selectedImages.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('이미지와 내용을 모두 입력해주세요!')),
                        );
                        return;
                      }

                      vm.setUploading(true);

                      List<String> imageUrls = await vm.uploadImages(
                        state.selectedImages,
                      );

                      if (imageUrls.isEmpty) {
                        vm.setUploading(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('이미지 업로드에 실패하였습니다.')),
                        );
                        return;
                      }

                      final newPost = Post(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: userState.uid,
                        userNickname: userState.userNickname,
                        userProfileImageUrl: userState.profileImgUrl,
                        imageUrls: imageUrls,
                        tags: _tagController.text
                            .split(' ') // 띄어쓰기로 구분!
                            .where((tag) => tag.startsWith('#'))
                            .toList(),
                        content: _contentController.text,
                        createdAt: DateTime.now(),
                        likeCount: 0,
                        commentCount: 0,
                        likedBy: [],
                      );

                      await vm.addPost(newPost);
                      vm.setUploading(false);

                      if (mounted) context.pop();
                    },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF613EEA),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: state.isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      '업로드',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
