import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/model/login_model.dart';
import 'package:senthil/view/home_screen.dart';
import 'package:senthil/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4))
          ..forward();
    _animation = Tween<double>(begin: 0.05, end: 1.0).animate(_controller);
    loadScreen();
    super.initState();
  }

  void loadScreen() async {
    await Future.delayed(Duration(seconds: 4), () async {
      late SharedPreferences preferences;
      preferences = await SharedPreferences.getInstance();
      var data = preferences.getString('user');
      if (data != null) {
        final user = loginModelFromJson(data);
        ref.read(LoginController.userProvider.notifier).state = user;
        Get.offAll(() => HomeScreen(), transition: Transition.zoom);
      } else {
        Get.offAll(() => LoginScreen(), transition: Transition.zoom);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Senthil Group of Schools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
