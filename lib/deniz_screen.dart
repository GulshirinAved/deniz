// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DenizScreen extends StatefulWidget {
  final String url;
  const DenizScreen({super.key, required this.url});

  @override
  State<DenizScreen> createState() => _DenizScreenState();
}

class _DenizScreenState extends State<DenizScreen> {
  late WebViewController controller;
  bool isLoading = true;
  String? errorMessage;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  this.progress = progress / 100.0;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
              },

              onHttpError: (HttpResponseError error) {
                setState(() {
                  isLoading = false;
                  errorMessage = 'HTTP Error: ${error.response?.statusCode}';
                });
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  isLoading = false;
                  errorMessage = 'WebView Error: ${error.description}';
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          );

    _loadUrl();
  }

  void _loadUrl() {
    String url = widget.url;

    url = 'http://$url';

    try {
      controller.loadRequest(Uri.parse(url));
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Invalid URL: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deniz'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadUrl),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            if (errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ошибка загрузки',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUrl,
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
