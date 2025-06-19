import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/login_model.dart';
import 'package:senthil/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  static final isLoading = StateProvider.autoDispose((ref) => false);
  static final isChecked = StateProvider.autoDispose((ref) => false);
  static final canShowPassword = StateProvider.autoDispose((ref) => false);
  static final userProvider = StateProvider<LoginModel?>((ref) => null);

  static Future<void> login(
      String username, String password, WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final res = await AppController.send(
        'login', {'username': username, 'password': password});
    final result = loginModelFromJson(res);
    if (result.success) {
      await preferences.setString('user', res);
      ref.read(userProvider.notifier).state = result;
      Get.offAll(() => HomeScreen(), transition: Transition.zoom);
      AppController.toastMessage(
          'Login Successfully!', 'Welcome back ${result.data.fullname}.');
    } else {
      AppController.toastMessage(
          'User not found!', 'Please verify your login credentials.',
          purpose: Purpose.fail);
    }
  }
}
