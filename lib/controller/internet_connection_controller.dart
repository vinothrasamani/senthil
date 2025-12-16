import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void listenConnectivity(void Function(bool) onChanged) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      bool hasInternet = await cenckConnection(result);
      onChanged(hasInternet);
    });
  }

  Future<bool> cenckConnection(List<ConnectivityResult> result) async {
    final connected = [
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.wifi,
    ];
    return result.any((e) => connected.contains(e));
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
