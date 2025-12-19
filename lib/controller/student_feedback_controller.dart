import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_form_model.dart';
import 'package:senthil/model/feedback_home_model.dart';
import 'package:senthil/view/stud_feedback/feedback_start_screen.dart';
import 'package:senthil/view/stud_feedback/thankyou_screen.dart';
import 'package:senthil/widgets/student_feedback/subject_selection.dart';

class StudentFeedbackController {
  static final school = StateProvider.autoDispose<String?>((ref) => null);
  static final className = StateProvider.autoDispose<String?>((ref) => null);
  static final section = StateProvider.autoDispose<String?>((ref) => null);
  static final board = StateProvider.autoDispose<String?>((ref) => null);
  static final subject = StateProvider.autoDispose<String?>((ref) => null);
  static final refGrp = StateProvider.autoDispose<String?>((ref) => null);
  static final loading = StateProvider.autoDispose<bool>((ref) => false);
  static final fetching = StateProvider.autoDispose<bool>((ref) => false);
  static final isSubject = StateProvider.autoDispose<bool>((ref) => false);
  static final feedData =
      StateProvider.autoDispose<FeedbackFormModel?>((ref) => null);
  static final schoolList =
      StateProvider.autoDispose<List<String>>((ref) => []);
  static final classList = StateProvider.autoDispose<List<String>>((ref) => []);
  static final subjectList =
      StateProvider.autoDispose<List<String>>((ref) => []);
  static final sectionList =
      StateProvider.autoDispose<List<String>>((ref) => []);

  static final credentials = FutureProvider.family
      .autoDispose<FeedbackHomeModel, int>((ref, id) async {
    final res = await AppController.fetch('feed-home/$id');
    return feedbackHomeModelFromJson(res);
  });

  static void startFeedback(WidgetRef ref, Object object) async {
    try {
      ref.read(fetching.notifier).state = true;
      final res = await AppController.send('start-feedback', object);
      if (res == null) return null;
      final data = feedbackFormModelFromJson(res);
      ref.read(feedData.notifier).state = data;
      ref.read(fetching.notifier).state = false;
    } catch (e) {
      ref.read(fetching.notifier).state = false;
    }
  }

  static void submitFeedback(WidgetRef ref, Object object, int id) async {
    try {
      ref.read(fetching.notifier).state = true;
      final res = await AppController.send('store-feedback-data/$id', object);
      if (res == null) return null;
      final data = jsonDecode(res);
      if (data['success']) {
        ref.read(school.notifier).state = null;
        ref.read(className.notifier).state = null;
        ref.read(section.notifier).state = null;
        ref.read(refGrp.notifier).state = null;
        ref.read(subject.notifier).state = null;
        ref.read(fetching.notifier).state = false;
        Get.off(() => ThankYouScreen(),
            transition: Transition.rightToLeftWithFade);
      }
    } catch (e) {
      ref.read(fetching.notifier).state = false;
    }
  }

  static void setData(WidgetRef ref, String url, int id, Object object) async {
    switch (url) {
      case 'feed-home-school':
        final res = await AppController.send('$url/$id', object);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(schoolList.notifier).state =
              List<String>.from(decrypted['data'] ?? []);
        }
        break;
      case 'feed-home-class':
        final res = await AppController.send('$url/$id', object);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(classList.notifier).state =
              List<String>.from(decrypted['data'] ?? []);
        }
        break;
      case 'feed-home-section':
        final res = await AppController.send('$url/$id', object);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(sectionList.notifier).state =
              List<String>.from(decrypted['data'] ?? []);
        }
        break;
      case 'feed-home-subject':
        final res = await AppController.send(url, object);
        final decrypted = jsonDecode(res);
        if (decrypted['success']) {
          ref.read(subjectList.notifier).state =
              List<String>.from(decrypted['data'] ?? []);
        }
        break;
      default:
    }
  }

  static void chackSubjectAvailability(
      WidgetRef ref, Map<String, dynamic> object) async {
    try {
      ref.read(loading.notifier).state = true;
      final res = await AppController.send('check-availability', object);
      final result = jsonDecode(res);
      if (result['success']) {
        ref.read(loading.notifier).state = false;
        Get.to(() => FeedbackStartScreen(info: object),
            transition: Transition.rightToLeftWithFade);
      } else {
        ref.read(loading.notifier).state = false;
        AppController.toastMessage('Result', result['message']);
      }
    } catch (e) {
      ref.read(loading.notifier).state = false;
      AppController.toastMessage(
        'Error',
        'Something went wrong!',
        purpose: Purpose.fail,
      );
    }
  }

  static void selectSubjects(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => SubjectSelection(),
    );
  }
}
