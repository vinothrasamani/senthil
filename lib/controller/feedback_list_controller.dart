import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';

class FeedbackListController {
  static final loadItems =
      FutureProvider.autoDispose<FeedbackItemsModel>((ref) async {
    final str = await AppController.fetch('feedback-list');
    return feedbackItemsModelFromJson(str);
  });
}
