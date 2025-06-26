import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key, required this.pdfName});
  final String pdfName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfName.split('_').last),
      ),
      body: SfPdfViewer.network('${AppController.basefileUrl}/$pdfName'),
    );
  }
}
