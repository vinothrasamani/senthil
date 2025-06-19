import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/model/login_model.dart';
import 'package:senthil/view/home_screen.dart';
import 'package:senthil/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Senthil Group of Schools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 200,
            child: FlutterSplashScreen.scale(
              asyncNavigationCallback: () async {
                await Future.delayed(Duration(seconds: 4), () async {
                  late SharedPreferences preferences;
                  preferences = await SharedPreferences.getInstance();
                  var data = preferences.getString('user');
                  if (data != null) {
                    final user = loginModelFromJson(data);
                    ref.read(LoginController.userProvider.notifier).state =
                        user;
                    Get.offAll(() => HomeScreen(), transition: Transition.zoom);
                  } else {
                    Get.offAll(() => LoginScreen(),
                        transition: Transition.zoom);
                  }
                });
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              animationDuration: Duration(seconds: 3),
              childWidget: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png')),
            ),
          ),
        ],
      ),
    );
  }
}
