import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/notice_model.dart';
import 'package:senthil/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  static final canShowResult = StateProvider((ref) => false);
  static final canShowCollection = StateProvider((ref) => false);
  static final isResultBlocked = StateProvider((ref) => false);
  static final isCollectionBlocked = StateProvider((ref) => false);
  static final defaultPayment = StateProvider((ref) => 0);

  static void setResultAction(bool result) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('canShowResult', result);
  }

  static void setCollectionAction(bool result) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('canShowCollection', result);
  }

  static void setPayType(int result) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('payment', result);
  }

  static void loadSettings(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final c = preferences.getBool('canShowResult') ?? false;
    ref.read(canShowResult.notifier).state = c;
    final co = preferences.getBool('canShowCollection') ?? false;
    ref.read(canShowCollection.notifier).state = co;
    final p = preferences.getInt('payment') ?? 0;
    ref.read(defaultPayment.notifier).state = p;
  }

  static void loadControls(WidgetRef ref) async {
    final str = await AppController.fetch('/get-notice?id=1');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = noticeModelFromJson(str);
    if (data.success) {
      final dash = data.data.dash == 1;
      final banner = data.data.banner == 1;
      ref.read(isCollectionBlocked.notifier).state = !dash;
      ref.read(isResultBlocked.notifier).state = !banner;
      if (!dash) {
        ref.read(canShowCollection.notifier).state = false;
      } else {
        final c = preferences.getBool('canShowCollection') ?? false;
        ref.read(canShowCollection.notifier).state = c;
      }
      if (!banner) {
        ref.read(canShowResult.notifier).state = false;
      } else {
        final c = preferences.getBool('canShowResult') ?? false;
        ref.read(canShowResult.notifier).state = c;
      }
    }
  }

  static void changeTheme(WidgetRef ref, bool isDark) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDark', isDark);
    ref.read(ThemeController.themeMode.notifier).state =
        isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void logout(WidgetRef ref) async {
    await Get.dialog(
      AlertDialog(
        title: Text(
          'Logging Out..',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text('Make sure do you wanna continue!'),
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text('No')),
          FilledButton(
            onPressed: () async {
              Get.back();
              final SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.remove('user');
              Get.offAll(() => LoginScreen(), transition: Transition.zoom);
              ref.read(LoginController.userProvider.notifier).state = null;
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
