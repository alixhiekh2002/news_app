import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebsitesClones extends StatefulWidget {
  final String webURL;
  const WebsitesClones({super.key, required this.webURL});

  @override
  State<WebsitesClones> createState() => _WebsitesClonesState();
}

class _WebsitesClonesState extends State<WebsitesClones> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(widget.webURL));

    // Set up callbacks for page loading
    _controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (String url) {
        setState(() {
          isLoading = true; // Show loading indicator
        });
      },
      onPageFinished: (String url) {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      },
      onWebResourceError: (error) {
        setState(() {
          isLoading = false; // Hide loading indicator in case of error
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "World News",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitChasingDots(
                color: const Color.fromARGB(255, 121, 255, 64),
                size: 50,
              ),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}
