import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/dio_services.dart';
import 'package:senthil/model/staff_details_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';
import 'package:senthil/view/staff_details/staff_info_screen.dart';

class StaffDetailCard extends StatefulWidget {
  const StaffDetailCard({super.key, required this.staff, required this.isDark});

  final StaffDetail staff;
  final bool isDark;

  @override
  State<StaffDetailCard> createState() => _StaffDetailCardState();
}

class _StaffDetailCardState extends State<StaffDetailCard> {
  bool isLoading = false, downloading = false, downloaded = false;
  double progress = 0.0;
  String name = '', path = '';

  @override
  void initState() {
    name =
        '${widget.staff.school}_${widget.staff.schooltype}_${widget.staff.code}_StaffDetail.pdf';
    if (!kIsWeb) {
      checkDownloads();
    }
    super.initState();
  }

  void checkDownloads() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/downloads');
    if (folder.existsSync()) {
      final file = File('${folder.path}/$name');
      if (file.existsSync()) {
        path = file.path;
        setState(() => downloaded = true);
      }
    }
  }

  void downloadPDF() async {
    setState(() => downloading = true);
    await DioServices.download(
      '${AppController.baseApiUrl}/staff-details-download/${widget.staff.id}',
      name,
      onProgress: (p) => setState(() {
        progress = p;
      }),
    );
    setState(() => downloading = false);
    checkDownloads();
  }

  void openFile() async {
    Get.to(() => PdfViewerScreen(fileName: path, isLocal: true),
        transition: Transition.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
          () => StaffInfoScreen(staff: widget.staff, file: path),
          transition: Transition.zoom),
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.withAlpha(80)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isLoading)
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                Checkbox(
                  activeColor: widget.isDark
                      ? AppController.lightGreen
                      : AppController.darkGreen,
                  value: widget.staff.showhide == 1,
                  onChanged: (val) async {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await AppController.fetch(
                        'staff-toggle-check/${widget.staff.id}');
                    final res = jsonDecode(result);
                    if (res != null) {
                      if (res['success']) {
                        widget.staff.showhide = res['data'];
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    widget.staff.staffName ?? "No name available!",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 6),
                if (!kIsWeb)
                  downloading
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.withAlpha(50),
                              color: AppController.headColor,
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: downloaded ? openFile : downloadPDF,
                          icon: Icon(downloaded
                              ? TablerIcons.file_text
                              : TablerIcons.download),
                        ),
              ],
            ),
            Wrap(
              spacing: 5,
              children: [
                Chip(
                  avatar: Icon(
                    TablerIcons.category,
                    color: AppController.headColor,
                  ),
                  label: Text(widget.staff.catPres ?? 'None'),
                ),
                Chip(
                  avatar: Icon(
                    TablerIcons.building_store,
                    color: AppController.yellow,
                  ),
                  label: Text(widget.staff.department ?? 'None'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
