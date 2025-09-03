import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // --- The list of URLs has been updated to use the Instagram Reels you provided ---
  // The URLs are converted to the 'embed' format for better WebView integration.
  final List<String> _reelUrls = [
    'https://www.instagram.com/reel/DKgXXTISRbR/?igsh=ZW5zZnF5ZGIwN3Bj',
    'https://www.instagram.com/reel/DMJ4-xBIESK/?igsh=MWhxc2YyZ3ZyMGx5MQ==',
    'https://www.instagram.com/reel/CtHx1Mbt-6P/?igsh=MWh2cG8zdHozZm9pbQ==',
    'https://www.instagram.com/reel/DGyBwgrKWSD/?igsh=aXVzYnVtcmVhYXV5',

  ];

  // A controller for each WebView instance to manage its state.
  late final List<WebViewController> _controllers;
  // A list to track the loading state of each individual WebView.
  late final List<bool> _isLoading;

  @override
  void initState() {
    super.initState();
    // Initialize the loading state for each reel to 'true'.
    _isLoading = List.generate(_reelUrls.length, (_) => true);

    // Initialize a WebViewController for each URL.
    _controllers = List.generate(
      _reelUrls.length,
          (index) {
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
        // Set a transparent background to see the Scaffold's color while loading.
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              // When the page finishes loading, update the state to hide the spinner.
              onPageFinished: (String url) {
                if (mounted) {
                  setState(() {
                    _isLoading[index] = false;
                  });
                }
              },
              // Log any errors that occur during page loading.
              onWebResourceError: (WebResourceError error) {
                debugPrint('''
                  Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                ''');
              },
              // --- Updated to allow navigation within the Instagram domain ---
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.instagram.com/')) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.prevent;
              },
            ),
          );
        // Load the request after the controller is configured.
        controller.loadRequest(Uri.parse(_reelUrls[index]));
        return controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold provides the basic structure for the community page.
    return Scaffold(
      // Set the background to black for a cinematic, social media feel.
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          // Use a Stack to overlay a loading indicator on top of the WebView.
          return Stack(
            alignment: Alignment.center,
            children: [
              // The WebView for the reel.
              WebViewWidget(controller: _controllers[index]),
              // Show a loading indicator only if the page is still loading.
              if (_isLoading[index])
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
            ],
          );
        },
      ),
    );
  }
}

