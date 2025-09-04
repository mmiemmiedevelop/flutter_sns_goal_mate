import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/pages/provider/write_page_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final file = File(image.path);
      if (!file.existsSync()) return;

      ref.read(writePageViewModelProvider.notifier).selectImage(file);
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  Future<bool> _showExitDialog() async {
    final selectedImage = ref.read(writePageViewModelProvider).selectedImage;
    if (selectedImage != null ||
        _tagController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
      return (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text('나가시면 작성하신 게 지워져요'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('나가기'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writePageViewModelProvider);
    final vm = ref.read(writePageViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            if (await _showExitDialog()) Navigator.pop(context);
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(10),
                  image: state.selectedImage != null
                      ? DecorationImage(
                          image: FileImage(state.selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: state.selectedImage == null
                    ? Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _tagController,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                hintText: '#태그',
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
                      if (_contentController.text.isEmpty) return;

                      vm.setUploading(true);

                      String? imageUrl;
                      if (state.selectedImage != null) {
                        imageUrl = await vm.uploadImage(state.selectedImage!);
                      }

                      final newPost = Post(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: 'sorin_dev',
                        userNickname: '정소린',
                        userProfileImageUrl:
                            'https://placehold.co/100x100/F27272/FFFFFF?text=SR',
                        imageUrls: imageUrl != null ? [imageUrl] : [],
                        tags: _tagController.text.isNotEmpty
                            ? [_tagController.text]
                            : [],
                        content: _contentController.text,
                        createdAt: DateTime.now(),
                        likeCount: 0,
                        commentCount: 0,
                        likedBy: [],
                      );

                      await vm.addPost(newPost);
                      vm.setUploading(false);

                      Navigator.pop(context);
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
