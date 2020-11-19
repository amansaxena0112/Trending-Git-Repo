import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityUtil {
  static final ConnectivityUtil _connectivityUtil = ConnectivityUtil._();
  factory ConnectivityUtil() => _connectivityUtil;
  ConnectivityUtil._();

  bool _isConnectionActive;
  Connectivity _connectivity;
  BuildContext context;

  bool get isConnectionActive => _isConnectionActive;

  void init(BuildContext context) async {
    this.context = context;
    _connectivity = Connectivity();

    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _isConnectionActive = false;
      print('no network');
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('No polling!')));
    } else {
      print('network');
      _isConnectionActive = true;
    }
  }
}
