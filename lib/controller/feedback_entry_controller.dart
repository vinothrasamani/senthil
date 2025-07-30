import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_entry_model.dart';

class FeedbackEntryController {
  final years = StateProvider.autoDispose((ref) => []);
  final sessions = StateProvider.autoDispose((ref) => []);
  final schools = StateProvider.autoDispose((ref) => []);
  final schoolTypes = StateProvider.autoDispose((ref) => []);
  final searching = StateProvider.autoDispose<bool>((ref) => false);

  void setData(WidgetRef ref, String url, Object object) async {
    switch (url) {
      case 'feedback-entry-init':
        final res = await AppController.fetch(url);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(years.notifier).state = decrypted['data']['years'];
          ref.read(schoolTypes.notifier).state = decrypted['data']['types'];
          ref.read(sessions.notifier).state = decrypted['data']['sessions'];
        }
        break;
      case 'feedback-entry-schl':
        final res = await AppController.send(url, object);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(schools.notifier).state = decrypted['data'];
        }
        break;
      default:
    }
  }

  final fetchData = FutureProvider.family
      .autoDispose<List<FeedbackEntry>, Object>((ref, data) async {
    final res = await AppController.send('feedback-entry-search', data);
    final result = feedbackEntryModelFromJson(res);
    if (result.success) {
      return result.data;
    }
    return [];
  });
}
