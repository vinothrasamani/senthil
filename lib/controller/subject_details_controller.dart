import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/subject_details_model.dart';
import 'package:senthil/widgets/subject_details_edit.dart';

class SubjectDetailsController
    extends StateNotifier<AsyncValue<List<SubjectInfo>>> {
  SubjectDetailsController() : super(AsyncLoading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final res = await AppController.fetch('subject-details');
      final data = subjectDetailsModelFromJson(res);
      if (data.success) {
        state = AsyncData(data.data);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      AppController.toastMessage('Error', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }

  static void openEditor(BuildContext context, [SubjectInfo? info]) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SubjectDetailsEdit(info: info),
    );
  }

  void addOrEdit(Object object, bool canAdd) async {
    Get.back();
    if (canAdd) {
      final res = await AppController.send('add-subject-detail', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = SubjectInfo.fromJson(data['data']);
        state = AsyncData([...state.value!, item]);
        AppController.toastMessage(
            'Added!', 'Subject details Added Successfully!');
      }
    } else {
      final res = await AppController.send('update-subject-detail', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = SubjectInfo.fromJson(data['data']);
        final list = state.value!.map<SubjectInfo>((e) {
          if (item.id == e.id) {
            return item;
          } else {
            return e;
          }
        }).toList();
        state = AsyncData(list);
        AppController.toastMessage(
            'Edited!', 'Subject details Edited Successfully!');
      }
    }
  }

  void updateShow(int id, int val) {
    final list = state.value!.map((e) {
      if (e.id == id) {
        return e.copyWidth(val);
      } else {
        return e;
      }
    }).toList();
    state = AsyncData(list);
  }
}

final subjectDetailsProvider = StateNotifierProvider.autoDispose<
    SubjectDetailsController, AsyncValue<List<SubjectInfo>>>((ref) {
  return SubjectDetailsController();
});
