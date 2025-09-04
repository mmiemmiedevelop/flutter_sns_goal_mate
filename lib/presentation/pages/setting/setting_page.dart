import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_princess/domain/entity/user.dart';
import 'package:flutter_princess/presentation/common_widget/theme/theme.dart';
import 'package:flutter_princess/presentation/pages/user_view_model/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends ConsumerStatefulWidget {
  final User user;
  const SettingPage({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  late final TextEditingController _nicknameController;
  File? _selectedFile;
  bool _isChanged = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.user.userNickname);
    _nicknameController.addListener(() {
      if (widget.user.userNickname != _nicknameController.text) {
        setState(() => _isChanged = true);
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _selectedFile = File(image.path);
      _isChanged = true;
    });
  }

  Future<bool> _showExitDialog() async {
    if (!_isChanged) return true; // 변경사항 없을 시 그냥 나가기

    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('변경사항이 저장되지 않아요'),
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

  Future<void> _saveProfile() async {
    if (!_isChanged) {
      context.go('/home');
      return; // 변경사항 없을 시 그냥 나가기
    }
    setState(() => _isUploading = true);

    final vm = ref.read(userStateViewmodelProvider.notifier);
    final newNickname = _nicknameController.text;

    // String? newImageUrl;

    final success = await vm.editProfile(
      uid: widget.user.uid,
      userNickname: newNickname,
      imageFile: _selectedFile,
    );

    setState(() => _isUploading = false);

    if (mounted) {
      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('프로필 사진 저장에 실패했습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userStateViewmodelProvider)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            if (await _showExitDialog()) {
              context.go('/home');
            }
          },
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(color: Color(0xFF322626), fontSize: 20),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, color: Color(0xFFE5E5EA)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: _selectedFile != null
                      ? FileImage(_selectedFile!) as ImageProvider
                      : NetworkImage(state.profileImgUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color(0xFF613EEA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nicknameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(border: InputBorder.none),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isUploading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF613EEA),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(
                      color: GoalMateTheme.white,
                      strokeWidth: 3.0,
                    )
                  : const Text(
                      '저장하기',
                      style: TextStyle(
                        fontSize: 17,
                        color: GoalMateTheme.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
