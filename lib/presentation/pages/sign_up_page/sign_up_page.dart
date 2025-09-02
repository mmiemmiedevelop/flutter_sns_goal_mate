import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// 로그인 페이지
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //텍스트폼유효성검사
  final _formKey = GlobalKey<FormState>();

  //회원가입폼텍스트컨트롤러 선언
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  //이메일검증
  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return '이메일을 입력해주세요';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
    if (!ok) return '이메일 형식이 올바르지 않습니다';
    return null;
  }

  //페스워드검증
  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return '비밀번호를 입력해주세요';
    if (v.length < 6) return '비밀번호는 6자 이상이어야 합니다';
    return null;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _email.text.trim();
      final password = _password.text;
      if (_imageFile == null) {}

      //signupnicknamepage
      context.pushNamed(
        'signupnickname',
        extra: {
          'email': email,
          'password': password,
          'imageFile': _imageFile, // File?
        },
      );
      debugPrint('singuppage: $email / $password/$_imageFile');
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
    final height = size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: width * 0.2),
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 26),

            children: [
              Container(
                child: Text(
                  '나를 표현할 수 있는 \n프로필과 닉네임을 \n넣어주세요',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),

              //프로필 이미지
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
                  ],
                ),
              ),
              SizedBox(height: 50),
              //로그인폼
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next, //엔터누르면 다름필드로
                        decoration: InputDecoration(hintText: '이메일을 입력해주세요')
                            .copyWith(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        textInputAction:
                            TextInputAction.done, //엔터누르면 완료 ->onFieldSubmitted
                        decoration: InputDecoration(hintText: '비밀번호를 입력해주세요')
                            .copyWith(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                        validator: _validatePassword,
                        //onFieldSubmitted: (_) => _submit(),
                      ),
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
                          child: const Text('회원가입'),
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
