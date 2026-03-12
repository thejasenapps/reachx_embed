import 'package:flutter/material.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  static const route = "/webView";

  final Map<String, dynamic> arguments;

  const WebViewScreen({
    super.key,
    required this.arguments
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error loading page: ${error.description}")),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if(request.url.contains('example.com')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          }
        )
      )
    ..loadRequest(Uri.parse(widget.arguments["url"]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments["title"],
          style: const TextStyle(
            fontSize: 16
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                _controller.reload();
              },
              icon: const Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: () {
                _controller.goBack();
              },
              icon: const Icon(Icons.arrow_back)
          ),
          IconButton(
              onPressed: () {
                _controller.goForward();
              },
              icon: const Icon(Icons.arrow_forward)
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if(_isLoading)
            const Center(
              child: FlagWavingGif(),
            )
        ],
      ),
    );
  }
}
