import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/subject_handling_model.dart';

class SubjectHandlingController extends StateNotifier<List<HandlingSubject>> {
  SubjectHandlingController() : super([]);

  final years = StateProvider.autoDispose((ref) => []);
  final classNames = StateProvider.autoDispose((ref) => []);
  final sections = StateProvider.autoDispose((ref) => []);
  final schools = StateProvider.autoDispose((ref) => []);
  final schoolTypes = StateProvider.autoDispose((ref) => []);
  final searching = StateProvider.autoDispose<bool>((ref) => false);

  void setData(WidgetRef ref, String url, Object object) async {
    try {
      final res = await AppController.send(url, object);
      final decrypted = jsonDecode(res);
      if (decrypted['success']) {
        switch (url) {
          case 'initiate-handling':
            ref.read(years.notifier).state = decrypted['data']['years'];
            ref.read(schoolTypes.notifier).state = decrypted['data']['types'];
            break;
          case 'handling-schools':
            ref.read(schools.notifier).state = decrypted['data'];
            break;
          case 'handling-classes':
            ref.read(classNames.notifier).state = decrypted['data'];
            break;
          case 'handling-sections':
            ref.read(sections.notifier).state = decrypted['data'];
            break;
          default:
        }
      }
    } catch (e) {
      AppController.toastMessage('Error', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }

  Future<void> fetchData(Object data) async {
    final res = await AppController.send('search-subject-handling', data);
    final result = subjectHandlingModelFromJson(res);
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
        content: Text('Make sure do you wanna delete this handling info'),
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Get.back();
              final res =
                  await AppController.fetch('delete-subject-handling?id=$id');
              if (jsonDecode(res)['success']) {
                state = state.where((e) => e.id != id).toList();
              }
              AppController.toastMessage(
                  'Deleted!', 'Subject handling detail Deleted Successfully');
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

final subjectHandlingProvider = StateNotifierProvider.autoDispose<
    SubjectHandlingController, List<HandlingSubject>>((ref) {
  return SubjectHandlingController();
});
