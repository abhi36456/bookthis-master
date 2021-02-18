import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TcAndPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "By signing in, you agree to BookThis",
          style: TextStyle(color: Color(0xFF303043)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Text(
                "Terms and Conditions",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            Text(
              " and ",
              style: TextStyle(
                color: Color(0xFF303043),
              ),
            ),
            GestureDetector(
              child: Text(
                "Privacy Policy",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
