import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChapterWebview extends StatefulWidget {
  final String pdfUrl;
  ChapterWebview({this.pdfUrl});
  _ChapterWebviewState createState() => _ChapterWebviewState();
}

class _ChapterWebviewState extends State<ChapterWebview> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chapters"),
      ),
      body: WebView(
        initialUrl:
            ("https://docs.google.com/gview?embedded=true&url=${widget.pdfUrl}"),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
