import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int _maxCharacters = 100;
  int _currentCharacters = 0;
  File? _selectedImage;

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
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<bool> _showExitDialog() async {
    if (_selectedImage != null ||
        _tagController.text.isNotEmpty ||
        _contentController.text.isNotEmpty) {
      return (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              // title: const Text('경고'),
              content: const Text('나가시면 작성하신 게 지워저요'),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            bool shouldPop = await _showExitDialog();
            if (shouldPop) {
              Navigator.pop(context);
            }
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
          children: <Widget>[
            const SizedBox(height: 60),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(10),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF613EEA),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
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
