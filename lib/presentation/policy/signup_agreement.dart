// signup_agreement.dart
import 'package:flutter/material.dart';
import 'package:flutter_princess/presentation/policy/policy_web_view.dart';

const termsUrl =
    'https://fate-friend-339.notion.site/Goal-Mate-268e795aec4c806fa80ef443feb6eac1';

class SignupAgreement extends StatefulWidget {
  final VoidCallback onAgreed;
  const SignupAgreement({super.key, required this.onAgreed});

  @override
  State<SignupAgreement> createState() => _SignupAgreementState();
}

class _SignupAgreementState extends State<SignupAgreement> {
  bool agreeTerms = false;

  void _open(BuildContext ctx, String url, String title) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => PolicyWebViewPage(url: url, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () =>
                        _open(context, termsUrl, '이용약관 · 개인정보 처리방침'),
                    child: const Text('전체 화면으로 보기'),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: PolicyWebViewPage(
                    url: termsUrl,
                    title: '이용약관 · 개인정보 처리방침',
                  ),
                ),
                // TextButton(
                //   onPressed: () => _open(context, termsUrl, '이용약관,개인정보 처리방침'),
                //   child: const Text('이용약관 보기'),
                // ),
              ],
            ),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('[필수] 이용약관,개인정보 처리방침에 동의합니다'),
              value: agreeTerms,
              onChanged: (v) => setState(() => agreeTerms = v ?? false),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!agreeTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('필수 약관에 모두 동의해 주세요')),
                    );
                    return;
                  }
                  widget.onAgreed();
                },
                child: const Text('동의하고 회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
