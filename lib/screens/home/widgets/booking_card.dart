import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final image;
  final title;
  final subTitle;
  final onPressed;

  BookingCard({this.image, this.title, this.subTitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/$image",
              height: 50,
              width: 70,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(color: AppColors.lightText, fontSize: 20),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppColors.borderColor,
            ),
          ],
        ),
      ),
    );
  }
}
