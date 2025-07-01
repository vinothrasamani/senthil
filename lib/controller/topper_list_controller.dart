import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/topper_list_image_model.dart';
import 'package:senthil/model/topper_list_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class TopperListController {
  static final yearsTop = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final classesTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final coursegroupsTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final streamgroupsTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final coursesTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final examsTop = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final refGroupTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final subjectsTop =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final canAddTop = StateProvider.autoDispose<bool>((ref) => false);
  static final searchingTop = StateProvider.autoDispose<bool>((ref) => false);
  static void setDataTop(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    switch (url) {
      case 'years-top':
        ref.read(yearsTop.notifier).state = decrypted['data'];
        break;
      case 'classes-top':
        ref.read(classesTop.notifier).state = decrypted['data'];
        ref.read(examsTop.notifier).state = [];
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'exams-top':
        ref.read(examsTop.notifier).state = decrypted['data'];
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'courses-top':
        ref.read(coursesTop.notifier).state = decrypted['data'];
        break;
      case 'course-group-top':
        ref.read(coursegroupsTop.notifier).state = decrypted['data'];
        break;
      case 'stream-group-top':
        ref.read(streamgroupsTop.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final classTopperData =
      FutureProvider.family<TopperListModel, Object>((ref, data) async {
    final res = await AppController.send('topper-list-search', data);
    ref.read(searchingTop.notifier).state = false;
    return topperListModelFromJson(res);
  });

  static void openImage(BuildContext context, String image, String name) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(name), leading: Icon(Icons.person)),
            Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(image, fit: BoxFit.cover),
            ),
            SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () => Get.back(), child: Text('Cloase')),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(2),
      ),
    );
  }

  static void listDocs(
      BuildContext context, List<dynamic> list, bool isDark) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => ListView(
        children: [
          AppController.heading('Available Documents', isDark),
          SizedBox(height: 10),
          for (var item in list)
            if (item.filename != null && item.filename.isNotEmpty)
              ListTile(
                leading: Builder(builder: (context) {
                  final link = item.photo == null || item.photo.isEmpty
                      ? '${AppController.baseImageUrl}/placeholder.jpg'
                      : '${AppController.basefileUrl}/${item.photo}';
                  return CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(link),
                  );
                }),
                title: Text(item.studentName),
                trailing:
                    Icon(TablerIcons.file, color: AppController.lightBlue),
                onTap: () {
                  Get.back();
                  Get.to(() => PdfViewerScreen(fileName: item.filename));
                },
              ),
        ],
      ),
    );
  }

  static void setDataTopImage(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    switch (url) {
      case 'years-top-image':
        ref.read(yearsTop.notifier).state = decrypted['data'];
        break;
      case 'classes-top-image':
        ref.read(classesTop.notifier).state = decrypted['data'];
        ref.read(examsTop.notifier).state = [];
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'exams-top-image':
        ref.read(examsTop.notifier).state = decrypted['data'];
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'courses-top-image':
        ref.read(coursesTop.notifier).state = decrypted['data'];
        break;
      case 'course-group-top-image':
        ref.read(coursegroupsTop.notifier).state = decrypted['data'];
        break;
      case 'ref-group-top-image':
        ref.read(refGroupTop.notifier).state = decrypted['data'];
        break;
      case 'stream-group-top-image':
        ref.read(streamgroupsTop.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final classTopperImageData =
      FutureProvider.family<TopperListImageModel, Object>((ref, data) async {
    final res = await AppController.send('top-list-img-search', data);
    ref.read(searchingTop.notifier).state = false;
    return topperListImageModelFromJson(res);
  });
}
