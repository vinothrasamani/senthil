import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_view_model.dart';

class FeedbackController {
  static final years = StateProvider.autoDispose<List>((ref) => []);
  static final sessions = StateProvider.autoDispose<List>((ref) => []);
  static final schools = StateProvider.autoDispose<List>((ref) => []);
  static final classes = StateProvider.autoDispose<List>((ref) => []);
  static final refGroups = StateProvider.autoDispose<List>((ref) => []);
  static final sections = StateProvider.autoDispose<List>((ref) => []);
  static final searching = StateProvider.autoDispose((ref) => false);
  static final feedAvail = StateProvider.autoDispose((ref) => false);

  static void loadinitials(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    switch (url) {
      case 'feedback-initials':
        ref.read(years.notifier).state = decrypted['data']['years'];
        ref.read(sessions.notifier).state = decrypted['data']['sessions'];
        ref.read(schools.notifier).state = decrypted['data']['schools'];
        ref.read(refGroups.notifier).state = decrypted['data']['refGroups'];
        break;
      case 'feed-classes':
        ref.read(classes.notifier).state = decrypted['data'];
        break;
      case 'feed-secs':
        ref.read(sections.notifier).state = decrypted['data'];
        break;
      default:
    }
  }

  static final searchData = FutureProvider.family
      .autoDispose<FeedbackViewModel, Object>((ref, data) async {
    final res = await AppController.send('search-feedback', data);
    ref.read(searching.notifier).state = false;
    return feedbackViewModelFromJson(res);
  });
}
