import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late String currentUrl;
  late TextEditingController _controller;
  WebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.url;
    _controller = TextEditingController(text: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.home)),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade800.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _controller,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onSubmitted: (text) {
                            setState(() {
                              currentUrl = text;
                            });
                            webViewController?.loadUrl(text);
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.arrowLeft,
                        )),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.arrowRight),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
