import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class SavedPdf extends StatefulWidget {
  const SavedPdf({super.key, required this.file});
  final String file;

  @override
  State<SavedPdf> createState() => _SavedPdfState();
}

class _SavedPdfState extends State<SavedPdf> {
  var myImage;

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  void loadImage() async {
    final pdf = await PdfDocument.openFile(widget.file);
    final page = await pdf.getPage(1);
    final img = await page.render(
        width: page.width.toInt(), height: page.height.toInt());
    final image = await img.createImageIfNotAvailable();
    setState(() => myImage = image);
    pdf.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Get.to(() => PdfViewerScreen(fileName: widget.file, isLocal: true),
              transition: Transition.zoom);
        },
        child: Container(
          width: 250,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(60),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 120,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(206, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: myImage != null
                    ? RawImage(
                        image: myImage,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(TablerIcons.file_text,
                            size: 50, color: Colors.black),
                      ),
              ),
              SizedBox(height: 5),
              Text(
                widget.file.split('/').last,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
