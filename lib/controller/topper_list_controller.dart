import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/topper_list_model.dart';

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
  static final examsTop =
      StateProvider.autoDispose<List<Map<String, dynamic>>>((ref) => []);
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
      case 'years':
        List y = decrypted['data'];
        ref.read(yearsTop.notifier).state = y.isEmpty ? [''] : y;
        break;
      case 'classes':
        ref.read(classesTop.notifier).state = decrypted['data'];
        ref.read(examsTop.notifier).state = [];
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'exams':
        ref.read(examsTop.notifier).state =
            List<Map<String, dynamic>>.from(decrypted['data']);
        ref.read(coursesTop.notifier).state = [];
        ref.read(coursegroupsTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'course-group':
        ref.read(coursegroupsTop.notifier).state = [
          'All',
          ...decrypted['data']
        ];
        ref.read(coursesTop.notifier).state = [];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'courses':
        ref.read(coursesTop.notifier).state = ['All', ...decrypted['data']];
        ref.read(streamgroupsTop.notifier).state = [];
        break;
      case 'stream-group':
        ref.read(streamgroupsTop.notifier).state = [
          'All',
          ...decrypted['data']
        ];
        break;
      case 'ref-group':
        ref.read(refGroupTop.notifier).state = ['All', ...decrypted['data']];
        break;
      default:
    }
  }

  static final classTopperData = FutureProvider.family
      .autoDispose<TopperListModel, Object>((ref, data) async {
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
            Container(height: 0.5, color: Colors.grey, width: double.infinity),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(4),
              constraints: BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 30,
                        color: Colors.redAccent.withAlpha(160),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () => Get.back(), child: Text('Close')),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(2),
      ),
    );
  }
}
