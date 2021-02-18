import 'dart:async';

import 'package:bookthis/screens/home/home.dart';
import 'package:bookthis/screens/login/login.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() {
    Timer(Duration(seconds: 3), navigate);
  }

  void navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("id"))
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
    else
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
