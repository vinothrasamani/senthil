import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';
import 'package:senthil/widgets/feedback/edit_feedback.dart';

class FeedbackListController {
  static final loadItems =
      FutureProvider.autoDispose<FeedbackItemsModel>((ref) async {
    final str = await AppController.fetch('feedback-list');
    return feedbackItemsModelFromJson(str);
  });

  static Future<bool> updateFeedback(int id) async {
    final str = await AppController.fetch('feedback-update?id=$id');
    if (jsonDecode(str)['success']) {
      return true;
    } else {
      return false;
    }
  }

  static void openEditSheet(BuildContext context, FeedbackItem? feedback,
      Function(FeedbackItem) onUpdate) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => EditFeedback(
        feedback: feedback,
        onUpdate: onUpdate,
      ),
    );
  }
}
