import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:senthil/controller/app_controller.dart';

class InternetConnectionController {
  static StreamSubscription<InternetStatus>? subscription;

  static void listenInternet(BuildContext context) async {
    subscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        bool isConnected = status == InternetStatus.connected;
        if (context.mounted) {
          AppController.showSnackBar(
            context,
            isConnected
                ? 'Has an Active Internet Connection!'
                : 'No Internet Connectivity!',
            isConnected,
          );
        }
      },
    );
  }

  static void dispose() async {
    await subscription?.cancel();
  }
}
