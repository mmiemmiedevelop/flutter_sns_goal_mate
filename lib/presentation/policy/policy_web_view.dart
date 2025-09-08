// policy_webview_page.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const PolicyWebViewPage({super.key, required this.url, required this.title});

  @override
  State<PolicyWebViewPage> createState() => _PolicyWebViewPageState();
}

class _PolicyWebViewPageState extends State<PolicyWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
