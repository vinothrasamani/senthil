import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen(
      {super.key,
      required this.fileName,
      this.isLocal = false,
      this.fromQs = false});
  final String fileName;
  final bool fromQs;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLocal ? fileName.split('/').last : fileName),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: isLocal
            ? SfPdfViewer.file(File(fileName))
            : SfPdfViewer.network(
                '${fromQs ? AppController.baseQusUrl : AppController.basefileUrl}/$fileName',
              ),
      ),
    );
  }
}
