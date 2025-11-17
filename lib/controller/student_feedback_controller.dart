import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_home_model.dart';

class StudentFeedbackController {
  static final credentials = FutureProvider.family
      .autoDispose<FeedbackHomeModel, int>((ref, id) async {
    final res = await AppController.fetch('feed-home/$id');
    return feedbackHomeModelFromJson(res);
  });
}
