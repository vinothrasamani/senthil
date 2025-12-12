import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/consistency_model.dart';

class ConsistencyController {
  static final conYears = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conClasses =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final conCourses =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final searchingTop = StateProvider.autoDispose<bool>((ref) => false);
  static void setConData(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    switch (url) {
      case 'years':
        List y = decrypted['data'];
        ref.read(conYears.notifier).state = y.isEmpty ? [''] : y;
        break;
      case 'classes':
        ref.read(conClasses.notifier).state = decrypted['data'];
        ref.read(conCourses.notifier).state = [];
        break;
      case 'con-courses':
        ref.read(conCourses.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final conData = FutureProvider.family
      .autoDispose<ConsistencyModel, Object>((ref, data) async {
    final res = await AppController.send('consistency-search', data);
    ref.read(searchingTop.notifier).state = false;
    return ConsistencyModel.fromJson(jsonDecode(res));
  });
}
