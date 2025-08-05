import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
int random() {
  return Random().nextInt(1000);
}

//-----------firebase messaging----------------
Future<String> requestNotificationPermission() async {
  final res = await messaging.requestPermission();
  if (res.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    return token ?? 'Token is null..';
  } else {
    return 'Unable to send notifications..';
  }
}

void createNotification(RemoteMessage event) {
  if (event.notification != null) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random(),
        channelKey: 'senthil',
        largeIcon: 'asset://assets/images/logo.png',
        icon: 'resource://drawable/ic_notification',
        title: event.notification?.title ?? "Empty title",
        body: event.notification?.body ?? "Empty body",
        wakeUpScreen: true,
        backgroundColor: const Color.fromARGB(255, 17, 0, 172),
        notificationLayout: NotificationLayout.Messaging,
      ),
    );
  }
}

void loadFirebaseMessaging() async {
  FirebaseMessaging.onMessage.listen((event) {
    createNotification(event);
  });

  FirebaseMessaging.onBackgroundMessage((message) async {
    createNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    createNotification(event);
  });
}
//-------------------------------------------------

Future<void> sendNotification(String body) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: random(),
      channelKey: 'senthil',
      title: 'Senthil School',
      body: body,
      largeIcon: 'asset://assets/images/logo.png',
      icon: 'resource://drawable/ic_notification',
      wakeUpScreen: true,
      backgroundColor: const Color.fromARGB(255, 17, 0, 172),
      notificationLayout: NotificationLayout.Messaging,
    ),
  );
}
