import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/pages/user_view_model.dart/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 로그인 페이지
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  UserViewModel get vm => ref.read(userStateViewmodelProvider.notifier);
  //텍스트폼유효성검사
  final _formKey = GlobalKey<FormState>();

  //로그인폼텍스트컨트롤러 선언
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
      // TODO: 로그인 처리
      vm.login(email, password);
      //debugPrint('login: $email / $password');
      if (UserState != null) {
        context.pushNamed('home');
      } else {
        print('UserState is null');
      }
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
          padding: EdgeInsets.only(top: width * 0.3),
          width: double.infinity,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 26),

            children: [
              //logos 이미지
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/img/logos.png'),
                  Text('당신의 목표, 함께 달성해요.'),
                ],
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
                        onFieldSubmitted: (_) => _submit(),
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
                          child: const Text('로그인'),
                        ),
                      ),
                      SizedBox(height: 25),
                      TextButton(
                        onPressed: () {
                          context.pushNamed('signup');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: Text('회원가입'),
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
