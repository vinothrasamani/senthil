import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/notice_model.dart';

class NoticeController {
  static final message = StateProvider.autoDispose((ref) => false);
  static final banner = StateProvider.autoDispose((ref) => false);
  static final dashboard = StateProvider.autoDispose((ref) => false);
  static final updating = StateProvider.autoDispose((ref) => false);

  static final noticeData =
      FutureProvider.family.autoDispose<NoticeData, int>((ref, id) async {
    final str = await AppController.fetch('/get-notice?id=$id');
    final data = noticeModelFromJson(str);
    ref.read(NoticeController.message.notifier).state = data.data.active == 1;
    ref.read(NoticeController.banner.notifier).state = data.data.banner == 1;
    ref.read(NoticeController.dashboard.notifier).state = data.data.dash == 1;
    return data.data;
  });

  static void update(WidgetRef ref, Object object) async {
    ref.read(updating.notifier).state = true;
    final res = await AppController.send('set-notice', object);
    if (res != null) {
      final data = jsonDecode(res);
      if (data['success']) {
        AppController.toastMessage('Success!', data['message']);
      } else {
        AppController.toastMessage('Failed!', data['message'],
            purpose: Purpose.fail);
      }
    }
    ref.read(updating.notifier).state = false;
  }
}
