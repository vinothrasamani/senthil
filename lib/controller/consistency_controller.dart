import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/consistency_model.dart';

class ConsistencyController {
  static final conYears = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conClasses =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conCoursegroups =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conStreamgroups =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conCourses =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conRefGroup =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final canAddTop = StateProvider.autoDispose<bool>((ref) => false);
  static final searchingTop = StateProvider.autoDispose<bool>((ref) => false);
  static void setConData(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    switch (url) {
      case 'con-years':
        ref.read(conYears.notifier).state = decrypted['data'];
        break;
      case 'con-classes':
        ref.read(conClasses.notifier).state = decrypted['data'];
        ref.read(conCourses.notifier).state = [];
        ref.read(conCoursegroups.notifier).state = [];
        ref.read(conStreamgroups.notifier).state = [];
        break;
      case 'con-courses':
        ref.read(conCourses.notifier).state = decrypted['data'];
        break;
      case 'con-course-group':
        ref.read(conCoursegroups.notifier).state = decrypted['data'];
        break;
      case 'con-stream-group':
        ref.read(conStreamgroups.notifier).state = decrypted['data'];
        break;
      case 'con-ref-group':
        ref.read(conRefGroup.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final conData = FutureProvider.family
      .autoDispose<ConsistencyModel, Object>((ref, data) async {
    final res = await AppController.send('consistency-search', data);
    ref.read(searchingTop.notifier).state = false;
    return consistencyModelFromJson(res);
  });
}
