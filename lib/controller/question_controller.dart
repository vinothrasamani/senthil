import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/question_model.dart';

class QuestionController {
  static final quesYears =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final quesClasses =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final quesExams =
      StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final searchingTop = StateProvider.autoDispose<bool>((ref) => false);

  static void setQuesData(WidgetRef ref, String url, Object object) async {
    final res = await AppController.send(url, object);
    final decrypted = jsonDecode(res);
    ref.read(quesYears.notifier).state = decrypted['data']['years'];
    ref.read(quesClasses.notifier).state = decrypted['data']['classes'];
    ref.read(quesExams.notifier).state = decrypted['data']['exams'];
  }

  static final questionData =
      FutureProvider.family<QuestionModel, Object>((ref, data) async {
    final res = await AppController.send('search-question', data);
    ref.read(searchingTop.notifier).state = false;
    return questionModelFromJson(res);
  });
}
