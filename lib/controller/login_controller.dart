import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/notification_controller.dart';
import 'package:senthil/model/login_model.dart';
import 'package:senthil/view/home_screen.dart';
import 'package:senthil/view/stud_feedback/feedback_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  static final isLoading = StateProvider.autoDispose((ref) => false);
  static final isChecked = StateProvider.autoDispose((ref) => false);
  static final canShowPassword = StateProvider.autoDispose((ref) => false);
  static final userProvider = StateProvider<LoginModel?>((ref) => null);

  static Future<void> login(
      String username, String password, WidgetRef ref) async {
    try {
      String? token;
      if (!kIsWeb) {
        token = await requestNotificationPermission();
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final res = await AppController.send('login',
          {'username': username, 'password': password, 'token': token});
      final result = loginModelFromJson(res);
      if (result.success) {
        Widget screen = HomeScreen();
        await preferences.setString('user', res);
        ref.read(userProvider.notifier).state = result;
        if (result.data!.role == 6) {
          screen = FeedbackHomeScreen();
        }
        // else {
        //   AppController.toastMessage('Failed', 'Invalid User!.',
        //       purpose: Purpose.fail);
        //   return;
        // }
        Get.offAll(() => screen, transition: Transition.zoom);
        AppController.toastMessage(
            'Login Successfully!', 'Welcome back ${result.data!.fullname}.');
      } else {
        AppController.toastMessage(
            'User not found!', 'Please verify your login credentials.',
            purpose: Purpose.fail);
      }
    } catch (e) {
      AppController.toastMessage('Error!', 'Something went wrong!',
          purpose: Purpose.fail);
    }
  }
}
