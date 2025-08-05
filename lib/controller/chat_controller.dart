import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/messages_model.dart';

class ChatController extends StateNotifier<List<MessageItem>> {
  ChatController() : super([]);
  final Dio dio = Dio();
  static final isLoading = StateProvider.autoDispose((ref) => true);
  static final sending = StateProvider.autoDispose((ref) => false);
  static final progress = StateProvider.autoDispose<double>((ref) => 0);
  static final filePath = StateProvider.autoDispose<String?>((ref) => null);

  Future<void> loadMessages(Object object) async {
    final res = await AppController.send('fetch-all-messages', object);
    final data = messagesModelFromJson(res);
    if (data.success) {
      state = [...state, ...data.data];
    }
  }

  void listenForMessage(Object object) async {
    final res = await AppController.send('fetch-new-messages', object);
    final data = messagesModelFromJson(res);
    if (data.success) {
      state = [...state, ...data.data];
    }
  }

  static Future<List<String?>> picFile() async {
    final files = await FilePicker.platform.pickFiles(
      dialogTitle: 'Pick your file!',
      compressionQuality: 70,
      withData: true,
    );
    if (files != null) {
      return files.paths;
    } else {
      return [];
    }
  }

  Future<void> addMessages(Map<String, dynamic> object,
      {void Function(int, int)? onSendProgress, Function()? onDone}) async {
    if (object['file'] != null && object['file'] is String) {
      object['file'] = await MultipartFile.fromFile(
        object['file'],
        filename: object['file'].split('/').last,
      );
    }
    FormData formData = FormData.fromMap(object);
    await dio
        .post('${AppController.baseApiUrl}/add-new-message',
            data: formData,
            options: Options(headers: {"Accept-Encoding": "identity"}),
            onSendProgress: onSendProgress)
        .then((res) {
      final decrypted = jsonDecode(res.data);
      if (decrypted['success']) {
        onDone!();
      }
    }).catchError((onError) {
      AppController.toastMessage(
          'Error!', 'Something went wrong on sending message');
    });
  }

  static void updateMessage(int id) async {
    await AppController.fetch('update-message?id=$id');
  }

  void cancel() {
    dio.close();
  }
}

final chatsProvider =
    StateNotifierProvider.autoDispose<ChatController, List<MessageItem>>((ref) {
  return ChatController();
});
