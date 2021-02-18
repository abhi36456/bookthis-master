import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final text;

  Heading({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }
}
