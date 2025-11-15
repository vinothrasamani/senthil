import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/content_model.dart';
import 'package:senthil/widgets/content_edit.dart';

class ContentController extends StateNotifier<AsyncValue<ContentData>> {
  ContentController() : super(AsyncLoading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final res = await AppController.fetch('content');
      final data = contentModelFromJson(res);
      if (data.success) {
        state = AsyncData(data.data);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      AppController.toastMessage('Error', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }

  static void openEditor(BuildContext context, [SchoolData? info]) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      isScrollControlled: true,
      builder: (ctx) => ContentEdit(
        info: info,
      ),
    );
  }

  void addOrEdit(Object object, bool canAdd) async {
    Get.back();
    if (canAdd) {
      final res = await AppController.send('add-content', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = SchoolData.fromJson(data['data']);
        state = AsyncData(
          ContentData(
            cbse: [
              ...state.value!.cbse,
              if (item.ctype == 1 || item.ctype == 2) item
            ],
            matric: [
              ...state.value!.matric,
              if (item.ctype == 1 || item.ctype == 3) item
            ],
          ),
        );
        AppController.toastMessage('Added!', 'Content Added Successfully!');
      }
    } else {
      final res = await AppController.send('update-content', object);
      final data = jsonDecode(res);
      if (data['success']) {
        final item = SchoolData.fromJson(data['data']);
        state = AsyncData(
          ContentData(
            cbse: state.value!.cbse.map((e) {
              if (item.id == e.id) {
                return item;
              } else {
                return e;
              }
            }).toList(),
            matric: state.value!.matric.map((e) {
              if (item.id == e.id) {
                return item;
              } else {
                return e;
              }
            }).toList(),
          ),
        );
        AppController.toastMessage('Edited!', 'Content Edited Successfully!');
      }
    }
  }
}

final contentProvider = StateNotifierProvider.autoDispose<ContentController,
    AsyncValue<ContentData>>((ref) {
  return ContentController();
});
