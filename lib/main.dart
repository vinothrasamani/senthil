import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    getTheme();
    super.initState();
  }

  void getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final isDark = preferences.getBool('isDark') ?? false;
    ref.read(ThemeController.themeMode.notifier).state =
        isDark ? ThemeMode.dark : ThemeMode.light;
    if (!kIsWeb) {
      await FlutterWindowManagerPlus.addFlags(
          FlutterWindowManagerPlus.FLAG_SECURE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(ThemeController.themeMode);
    return GetMaterialApp(
      title: 'Senthil School',
      debugShowCheckedModeBanner: false,
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}
