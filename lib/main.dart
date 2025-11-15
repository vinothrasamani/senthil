import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/notification_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/firebase_options.dart';
import 'package:senthil/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void initNotification() async {
  AwesomeNotifications().initialize(
    'resource://drawable/ic_notification',
    [
      NotificationChannel(
        channelKey: 'senthil',
        channelName: 'senthil',
        channelDescription: 'Notification service from senthil school.',
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        icon: 'resource://drawable/ic_notification',
        enableLights: true,
        defaultColor: Colors.teal,
        ledColor: Colors.white,
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    loadFirebaseMessaging();
  }
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
    initNotification();
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
      title: 'Senthil Group of Schools',
      debugShowCheckedModeBanner: false,
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}
