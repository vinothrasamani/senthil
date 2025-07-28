import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';
import 'package:senthil/widgets/feedback/edit_feedback.dart';

class FeedbackListController extends StateNotifier<List<FeedbackItem>> {
  FeedbackListController() : super([]);
  static final isLoading = StateProvider((ref) => true);
  static final isEnabled = StateProvider((ref) => true);

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
}

final feedbackListProvider = StateNotifierProvider.autoDispose<
    FeedbackListController, List<FeedbackItem>>((ref) {
  return FeedbackListController();
});
