import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/class_topper_list_model.dart';

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
      FutureProvider.family<ClassTopperListModel, Object>((ref, data) async {
    print('Start!');
    final res = await AppController.send('topper-list-search', data);
    ref.read(searchingTop.notifier).state = false;
    print(res);
    return classTopperListModelFromJson(res);
  });

  static final subjectTopperData =
      FutureProvider.family<ClassTopperListModel, Object>((ref, data) async {
    final res = await AppController.send('topper-list-search', data);
    ref.read(searchingTop.notifier).state = false;
    return classTopperListModelFromJson(res);
  });
}
