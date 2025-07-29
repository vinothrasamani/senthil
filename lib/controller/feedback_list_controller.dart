import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';
import 'package:senthil/widgets/feedback/edit_feedback.dart';

class FeedbackListController extends StateNotifier<List<FeedbackItem>> {
  FeedbackListController() : super([]);
  static final isLoading = StateProvider.autoDispose((ref) => true);
  static final isEnabled = StateProvider.autoDispose((ref) => true);
  static final fStaff = StateProvider.autoDispose((ref) => false);
  static final fAnim = StateProvider.autoDispose((ref) => false);
  static final years = StateProvider.autoDispose((ref) => []);
  static final feedLoading = StateProvider.autoDispose((ref) => true);
  static final updating = StateProvider.autoDispose((ref) => false);

  Future<void> loadItems() async {
    final str = await AppController.fetch('feedback-list');
    final data = feedbackItemsModelFromJson(str);
    if (data.success) {
      state = data.data;
    }
  }

  void editFeedback(FeedbackItem item) {
    state = [
      for (var s in state)
        if (s.id == item.id) item else s
    ];
  }

  void addNew(FeedbackItem item) {
    state = [...state, item];
  }

  static Future<bool> updateFeedback(int id) async {
    final str = await AppController.fetch('feedback-update?id=$id');
    if (jsonDecode(str)['success']) {
      return true;
    } else {
      return false;
    }
  }

  static void openEditSheet(
      BuildContext context, FeedbackItem? feedback) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => EditFeedback(feedback: feedback),
    );
  }

  void updateShow(String valFor, WidgetRef ref) async {
    final value = ref.read(isEnabled);
    ref.read(isLoading.notifier).state = true;
    final str = await AppController.send(
        'update-feedback-show', {'value': value ? 1 : 0, 'valFor': valFor});
    if (jsonDecode(str)['success']) {
      AppController.toastMessage('Updated!', 'Questions updated!');
      if (valFor == 'All') {
        state = state.map((e) => e.copyWith(value)).toList();
      } else {
        state = state.map((e) {
          if (e.questype == valFor) {
            return e.copyWith(value);
          } else {
            return e;
          }
        }).toList();
      }
    }
    ref.read(isLoading.notifier).state = false;
  }

  static Future<void> updateNotice(Object object) async {
    final res = await AppController.send('feedback-settings-save', object);
    if (jsonDecode(res)['success']) {
      AppController.toastMessage(
          'Updated!', 'Feedback notice updated successfully!');
    }
  }
}

final feedbackListProvider = StateNotifierProvider.autoDispose<
    FeedbackListController, List<FeedbackItem>>((ref) {
  return FeedbackListController();
});
