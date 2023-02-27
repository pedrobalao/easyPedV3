import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show FlutterErrorDetails, kDebugMode;
import 'package:flutter/material.dart';
import '../utils/network_connectivity.dart';

class CErrorScreen extends StatefulWidget {
  const CErrorScreen({Key? key, required this.details}) : super(key: key);

  final FlutterErrorDetails details;
  @override
  State<CErrorScreen> createState() => _CErrorScreenState();
}

class _CErrorScreenState extends State<CErrorScreen> {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      setState(() {});
      // 3.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            string,
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: string == 'Offline'
          ? const Text(
              "Ups...Parece que está sem ligação à internet. Verifique a sua ligação por favor e volte a tentar.")
          : Text(
              "Ups...Algo não correu bem! Os nossos melhores engenheiros já estão a analisar. ${kDebugMode ? widget.details.exceptionAsString() : ''}"),
    );
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }
}
