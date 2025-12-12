import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_entry_model.dart';

class FeedbackEntryController extends StateNotifier<List<FeedbackEntry>> {
  FeedbackEntryController() : super([]);

  final years = StateProvider.autoDispose((ref) => []);
  final sessions = StateProvider.autoDispose((ref) => []);
  final schools = StateProvider.autoDispose((ref) => []);
  final schoolTypes = StateProvider.autoDispose((ref) => []);
  final searching = StateProvider.autoDispose<bool>((ref) => false);

  void setData(WidgetRef ref) async {
    final url = 'feedback-entry-init';
    final res = await AppController.fetch(url);
    final decrypted = jsonDecode(res);
    if (decrypted['success']) {
      ref.read(years.notifier).state = decrypted['data']['years'];
      ref.read(schoolTypes.notifier).state = decrypted['data']['types'];
      ref.read(sessions.notifier).state = decrypted['data']['sessions'];
      ref.read(schools.notifier).state = decrypted['data']['schools'];
    }
  }

  Future<void> fetchData(Object data) async {
    final res = await AppController.send('feedback-entry-search', data);
    final result = feedbackEntryModelFromJson(res);
    if (result.success) {
      state = result.data;
    }
  }

  void onDelete(int id) async {
    await Get.dialog(
      AlertDialog(
        title: Text(
          'Deleting..',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text('Make sure do you wanna delete this feedback'),
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Get.back();
              final res =
                  await AppController.fetch('delete-feedback-entry?id=$id');
              if (jsonDecode(res)['success']) {
                state = state.where((e) => e.id != id).toList();
              }
              AppController.toastMessage(
                  'Deleted!', 'Feedback Deleted Successfully');
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

final feedbackEntryProvider = StateNotifierProvider.autoDispose<
    FeedbackEntryController, List<FeedbackEntry>>((ref) {
  return FeedbackEntryController();
});
