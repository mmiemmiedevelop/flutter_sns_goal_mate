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
  //닉네임폼텍스트컨트롤러 선언
  late final TextEditingController _userNickName;
  //로그인로딩 상태
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _userNickName = TextEditingController();
    _imageFile = widget.imageFile;
    email = widget.email;
    password = widget.password;
  }

  @override
  void dispose() {
    _userNickName.dispose();
    super.dispose();
  }

  String? _validateUserNickName(String? v) {
    if (v == null) return '닉네임을 입력해주세요';
    final s = v.trim();
    if (s.isEmpty) return '닉네임을 입력해주세요';

    if (s.length < 2 || s.length > 16) return '닉네임은 2~16자여야 합니다.';

    // 허용 문자 + 시작/끝/연속 구분자 제약
    final re = RegExp(
      r'^(?![._])(?!.*[._]{2,})[A-Za-z0-9\uAC00-\uD7A3._]+(?<![._])$',
    );
    if (!re.hasMatch(s)) {
      return '한글/영문/숫자/._ 만 사용, 시작·끝 구분자 금지, 연속 구분자 금지';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final userNickname = _userNickName.text.trim();
      if (_imageFile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 이미지를 선택해주세요.')));
        return;
      }
      setState(() => _loading = true);
      try {
        final ok = await vm.signUp(
          email: email,
          password: password,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //화면사이즈 설정용 MediaQuery
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: width * 0.2),
              width: double.infinity,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 26),

                children: [
                  Container(
                    child: Text(
                      '나를 표현할 수 있는 \n프로필과 닉네임을 \n넣어주세요',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              ),
            ),
          ),
          if (_loading)
            IgnorePointer(
              ignoring: true,
              child: ColoredBox(
                color: Color(0x55000000),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      Center(child: Text('로그인중입니다.')),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
