import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;

  final _connectivity = Connectivity();
  final _controller = StreamController<List<ConnectivityResult>>.broadcast();

  Stream<List<ConnectivityResult>> get connectivityStream => _controller.stream;

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void initialise() {
    _connectivity.onConnectivityChanged.listen(_controller.add);
  }

  void dispose() => _controller.close();
}
