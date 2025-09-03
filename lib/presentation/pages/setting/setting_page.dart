// lib/setting/setting_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'setting_page_view_model.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingViewModelProvider);
    final vm = ref.read(settingViewModelProvider.notifier);

    final ImageProvider<Object> imageProvider = state.selectedFile != null
        ? FileImage(state.selectedFile!)
        : state.selectedUrl != null
        ? NetworkImage(state.selectedUrl!)
        : state.currentProfileUrl != null
        ? NetworkImage(state.currentProfileUrl!)
        : const NetworkImage(
            'https://static.cdn.kmong.com/gigs/jYcIZ1753511586.jpg?w=500',
          );

    Future<File?> pickImageFromGallery() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return File(image.path);
    }

    void _onAddButtonTap() async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('갤러리에서 선택'),
                  onTap: () async {
                    Navigator.pop(context);
                    final file = await pickImageFromGallery();
                    if (file != null) vm.selectFile(file);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('기존 사진 선택'),
                  onTap: () async {
                    Navigator.pop(context);
                    final urls = await vm.getProfileImages();
                    if (urls.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: urls.length,
                            itemBuilder: (_, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(urls[index]),
                                ),
                                title: Text('사진 ${index + 1}'),
                                onTap: () {
                                  vm.selectUrl(urls[index]);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                CircleAvatar(radius: 80, backgroundImage: imageProvider),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _onAddButtonTap,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF613EEA),
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
                if (state.isUploading)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              '나는짱이다',
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: state.isUploading ? null : () => vm.saveProfile(),
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
                      '저장하기',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
