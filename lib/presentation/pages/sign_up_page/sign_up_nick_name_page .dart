import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/common_widget/button.dart';
import 'package:flutter_princess/presentation/pages/user_view_model.dart/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// 로그인 페이지
class SignUpNickNamePage extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final File? imageFile;

  const SignUpNickNamePage({
    super.key,
    required this.email,
    required this.password,
    this.imageFile,
  });

  @override
  ConsumerState<SignUpNickNamePage> createState() => _SignUpNickNamePageState();
}

class _SignUpNickNamePageState extends ConsumerState<SignUpNickNamePage> {
  UserViewModel get vm => ref.read(userStateViewmodelProvider.notifier);
  late final String email;
  late final String password;
  //텍스트폼유효성검사
  final _formKey = GlobalKey<FormState>();

  //회원가입폼텍스트컨트롤러 선언
  late final TextEditingController _userNickName;

  @override
  void initState() {
    super.initState();
    _userNickName = TextEditingController();
    _imageFile = widget.imageFile;
    email = widget.email;
    password = widget.password;

    // print('$_imageFile $id $password');
  }

  @override
  void dispose() {
    _userNickName.dispose();
    super.dispose();
  }

  //닉네임검증
  String? _validateUserNickName(String? v) {
    if (v == null || v.isEmpty) return '닉네임을 입력해주세요';
    //final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
    //if (!ok) return '이메일 형식이 올바르지 않습니다';
    return null;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final userNickName = _userNickName.text.trim();
      if (_imageFile != null) {
        final ok = await vm.signUp(
          email: email,
          password: password,
<<<<<<< HEAD
          imgUrl: _imageFile!,
          userNickname: userNickname,
        );
        if (!mounted) return;
        if (ok) context.pushNamed('home');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        final msg = switch (e.code) {
          'email-already-in-use' => '이미 등록된 이메일입니다.',
          'invalid-email' => '이메일 형식이 올바르지 않습니다.',
          'weak-password' => '비밀번호는 6자 이상이어야 합니다.',
          (_) => '회원가입에 실패했습니다. 잠시 후 다시 시도해 주세요.',
        };
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      } finally {
        if (mounted)
          setState(() {
            _loading = false;
          });
=======
          imgUrl: _imageFile,
          userNickname: userNickName,
        );
        if (!mounted) return;
        if (ok) context.pushNamed('home');
>>>>>>> parent of a855628 (Merge branch 'dev' into feature/sorin-home-ui)
      }
    }
  }

  //여기서부터 프로필 이미지 업로드
  File? _imageFile; // 선택된 이미지 파일
  final ImagePicker _picker = ImagePicker();
  // 갤러리에서 이미지 선택
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        //TODO: 유저데이터 이미지 url파이어스토리지
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    //화면사이즈 설정용 MediaQuery
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: width * 0.2),
              width: double.infinity,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 26),
=======
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: width * 0.2),
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 26),
>>>>>>> parent of a855628 (Merge branch 'dev' into feature/sorin-home-ui)

            children: [
              Container(
                child: Text(
                  '나를 표현할 수 있는 \n프로필과 닉네임을 \n넣어주세요',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: _imageFile == null
                          ? const Color.fromARGB(255, 190, 190, 190)
                          : null,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF613EEA),
                        ),
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
<<<<<<< HEAD
                  ),
                  SizedBox(height: 15),
                  ProfilePicker(imageFile: _imageFile, onTap: _pickImage),
                  SizedBox(height: 50),
                  //로그인폼
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userNickName,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done, //엔터누르면 다름필드로
                          decoration: InputDecoration(hintText: '닉네임 입력해주세요')
                              .copyWith(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                          validator: _validateUserNickName,
                        ),
                        SizedBox(height: 15),
                        SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF613EEA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('시작하기'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //
                ],
=======
                  ],
                ),
>>>>>>> parent of a855628 (Merge branch 'dev' into feature/sorin-home-ui)
              ),
              SizedBox(height: 50),
              //로그인폼
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userNickName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done, //엔터누르면 다름필드로
                        decoration: InputDecoration(hintText: '닉네임 입력해주세요')
                            .copyWith(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                        validator: _validateUserNickName,
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF613EEA),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('시작하기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }
}
