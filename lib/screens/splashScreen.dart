import 'dart:async';

import '../screens/loginScreen.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _onShowLogin);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onShowLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(LoginScreen.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[600],
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          Image.asset(
            'assets/images/imageScreen.png',
            fit: BoxFit.cover,
            width: 300,
            height: 200,
          ),
          Flexible(
            flex: 2,
            child: SafeArea(
              child: FractionallySizedBox(widthFactor: 0.7),
            ),
          ),
          Flexible(
            flex: 2,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 64.0, horizontal: 16.0),
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
