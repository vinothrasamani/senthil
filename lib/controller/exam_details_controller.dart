import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/exam_details_model.dart';
import 'package:senthil/widgets/exam_details_edit.dart';

class ExamDetailsController extends StateNotifier<AsyncValue<List<Examinfo>>> {
  ExamDetailsController() : super(AsyncLoading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final res = await AppController.fetch('exam-details');
      final data = examDetailsModelFromJson(res);
      if (data.success) {
        state = AsyncData(data.data);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      AppController.toastMessage('Error', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }

  static void openEditor(BuildContext context, [Examinfo? info]) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => ExamDetailsEdit(
        info: info,
      ),
    );
  }

  void addOrEdit(Object object, bool canAdd) async {
    Get.back();
    if (canAdd) {
      final res = await AppController.send('add-exam-detail', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = Examinfo.fromJson(data['data']);
        state = AsyncData([...state.value!, item]);
        AppController.toastMessage(
            'Added!', 'Exam details Added Successfully!');
      }
    } else {
      final res = await AppController.send('update-exam-detail', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = Examinfo.fromJson(data['data']);
        final list = state.value!.map<Examinfo>((e) {
          if (item.id == e.id) {
            return item;
          } else {
            return e;
          }
        }).toList();
        state = AsyncData(list);
        AppController.toastMessage(
            'Edited!', 'Exam details Edited Successfully!');
      }
    }
  }
}

final examDetailsProvider = StateNotifierProvider.autoDispose<
    ExamDetailsController, AsyncValue<List<Examinfo>>>((ref) {
  return ExamDetailsController();
});
