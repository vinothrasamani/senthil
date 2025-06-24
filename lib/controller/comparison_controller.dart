import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/search_comparison_model.dart';

class ComparisonController {
  static final years = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final classes = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final refgroups =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final coursegroups =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final streamgroups =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final courses = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final exams = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final subjects = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final canAdd = StateProvider.autoDispose<bool>((ref) => false);
  static final searching = StateProvider.autoDispose<bool>((ref) => false);
  static void setData(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    print(decrypted);
    switch (url) {
      case 'years':
        ref.read(years.notifier).state = decrypted['data'];
        break;
      case 'classes':
        ref.read(classes.notifier).state = decrypted['data'];
        ref.read(exams.notifier).state = [];
        ref.read(courses.notifier).state = [];
        ref.read(coursegroups.notifier).state = [];
        ref.read(streamgroups.notifier).state = [];
        ref.read(refgroups.notifier).state = [];
        break;
      case 'exams':
        ref.read(exams.notifier).state = decrypted['data'];
        ref.read(courses.notifier).state = [];
        ref.read(coursegroups.notifier).state = [];
        ref.read(streamgroups.notifier).state = [];
        ref.read(refgroups.notifier).state = [];
        break;
      case 'courses':
        ref.read(courses.notifier).state = decrypted['data'];
        break;
      case 'course-group':
        ref.read(coursegroups.notifier).state = decrypted['data'];
        break;
      case 'stream-group':
        ref.read(streamgroups.notifier).state = decrypted['data'];
        break;
      case 'ref-group':
        ref.read(refgroups.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final tableData =
      FutureProvider.family<SearchComparisonModel, Object>((ref, data) async {
    final res = await AppController.send('comparison-search', data);
    ref.read(searching.notifier).state = false;
    return searchComparisonModelFromJson(res);
  });
}
