import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/staff_downloader_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class DownloadedPdfs extends ConsumerStatefulWidget {
  const DownloadedPdfs({super.key});

  @override
  ConsumerState<DownloadedPdfs> createState() => _DownloadedPdfsState();
}

class _DownloadedPdfsState extends ConsumerState<DownloadedPdfs> {
  @override
  void initState() {
    loadDownloads();
    super.initState();
  }

  void loadDownloads() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/downloads');
    if (folder.existsSync()) {
      final List<String> files = folder.listSync().map((e) => e.path).toList();
      ref.read(staffDownloaderControllerProvider.notifier).addFile(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    return Builder(builder: (context) {
      final files = ref.watch(staffDownloaderControllerProvider);
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppController.heading('Downloaded Staff Details', isDark,
                Icons.download_done_rounded),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: files.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final file = files[index];
                final name = file.split('/').last;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Get.to(
                      () => PdfViewerScreen(fileName: file, isLocal: true)),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: baseColor),
                    child: Center(
                      child: Icon(TablerIcons.file_text, color: Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      File(file).delete();
                      ref
                          .read(staffDownloaderControllerProvider.notifier)
                          .removeFile(file);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
