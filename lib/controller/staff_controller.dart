import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/staff_details_model.dart';

class StaffController {
  static final schools = StateProvider.autoDispose<List>((ref) => []);
  static final status = StateProvider.autoDispose<List>((ref) => []);
  static final categories = StateProvider.autoDispose<List>((ref) => []);
  static final departments = StateProvider.autoDispose<List>((ref) => []);
  static final searching = StateProvider.autoDispose((ref) => false);
  static final canExpand = StateProvider.autoDispose((ref) => false);

  static void setData(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    if (res != null) {
      final data = jsonDecode(res);
      switch (url) {
        case 'staff-schools':
          ref.read(schools.notifier).state = data['data'];
          break;
        case 'staff-categories':
          ref.read(categories.notifier).state = data['data'];
          break;
        case 'staff-dept':
          ref.read(departments.notifier).state = data['data'];
          break;
        default:
      }
    }
  }

  static final staffDetails = FutureProvider.family((ref, Object object) async {
    final res = await AppController.send('staff-details-search', object);
    ref.read(searching.notifier).state = false;
    return staffDetailsModelFromJson(res);
  });
}
