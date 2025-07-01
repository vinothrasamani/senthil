import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key, required this.fileName});
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: SfPdfViewer.network(
          '${AppController.basefileUrl}/$fileName',
        ),
      ),
    );
  }
}
