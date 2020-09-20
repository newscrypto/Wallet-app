import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth extends StatefulWidget {
  final Function() onComplete;

  BiometricAuth({this.onComplete});

  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  bool _isAuthorized = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _isAuthorized = authenticated;
    });
  }

  void _makeAuthentication() async {
    try {
      await _checkBiometrics();
      if (_canCheckBiometrics) {
        await _authenticate();
        if (_isAuthorized) widget.onComplete();
      } else {
        print("ad");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), _makeAuthentication);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
