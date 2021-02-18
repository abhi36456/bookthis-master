import 'package:bookthis/screens/splash/splash_screen.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookThis',
      theme: ThemeData(
        primarySwatch: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Avenir",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: StadiumBorder(),
            primary: AppColors.primaryColor,
            onSurface: AppColors.primaryColor[300],
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
