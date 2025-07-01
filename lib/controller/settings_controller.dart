import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
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
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('No')),
          FilledButton(
            onPressed: () async {
              final SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.remove('user');
              ref.read(LoginController.userProvider.notifier).state = null;
              Get.offAll(() => LoginScreen(), transition: Transition.zoom);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
