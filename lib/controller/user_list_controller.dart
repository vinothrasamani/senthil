import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/user_list_model.dart';

class UserListController {
  static final filteredUsers =
      StateProvider.autoDispose<List<UserList>>((ref) => []);
  static final selectedSchools =
      StateProvider.autoDispose<List<String>>((ref) => []);
  static final selectedBoards =
      StateProvider.autoDispose<List<String>>((ref) => []);
  static final selectedStds =
      StateProvider.autoDispose<List<String>>((ref) => []);
  static final updating = StateProvider.autoDispose<bool>((ref) => false);
  static final schools = ['SLM', 'DPI', 'KGI'];
  static final boards = ['CBSE', 'Matric'];
  static final standards = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
    'XII'
  ];

  static final getUsers =
      FutureProvider.autoDispose<List<UserList>>((ref) async {
    final str = await AppController.fetch('fetch-users');
    final data = userListtModelFromJson(str);
    if (data.success) {
      return data.data;
    } else {
      return [];
    }
  });

  static void filter(String val, WidgetRef ref, List<UserList> users) async {
    if (val.isEmpty) {
      ref.read(filteredUsers.notifier).state = users;
    } else {
      ref.read(filteredUsers.notifier).state = users
          .where((user) =>
              user.name.toLowerCase().contains(val.toLowerCase()) ||
              user.school.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
  }

  static Future<void> update(Object object) async {
    final str = await AppController.send('save-user', object);
    if (jsonDecode(str)['success']) {
      AppController.toastMessage(
          'Success', 'User details updated Successfully!');
    } else {
      AppController.toastMessage('Failed', 'Update failed. Try again!',
          purpose: Purpose.fail);
    }
  }

  static void confirm(int id, WidgetRef ref) async {
    await Get.defaultDialog(
      title: 'Confirm!',
      content: Text('Do you wanna delete this user!'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('No'),
        ),
        FilledButton(
          onPressed: () async {
            final str = await AppController.fetch('delete-user?id=$id');
            if (jsonDecode(str)['success']) {
              AppController.toastMessage(
                  'Success', 'User Deleted Successfully!');
              ref.read(UserListController.getUsers);
            } else {
              AppController.toastMessage('Failed', 'Failed to delete user!',
                  purpose: Purpose.fail);
            }
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
