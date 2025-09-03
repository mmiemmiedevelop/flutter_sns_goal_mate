// 공통 버튼 위젯
import 'dart:io';
import 'package:flutter/material.dart';

//프로필 선택
class ProfilePicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;
  const ProfilePicker({
    super.key,
    required this.imageFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: imageFile == null
                  ? const Color.fromARGB(255, 190, 190, 190)
                  : null,
              backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF613EEA),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
