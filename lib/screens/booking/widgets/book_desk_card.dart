import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BookDeskCard extends StatelessWidget {
  final image;
  final title;
  final onPressed;
  final selected;

  BookDeskCard({this.image, this.title, this.onPressed, this.selected = false});

  @override
  Widget build(BuildContext context) {
    var innerBorder = Border.all(
      width: 1.0,
      color: selected
          ? AppColors.primaryColor.withOpacity(0)
          : AppColors.borderColor,
    );

    var outerBorder = Border.all(
        width: 4.0,
        color: selected
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(0));
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: outerBorder,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: selected ? Color(0xFFECEAFE) : Colors.transparent,
            border: innerBorder,
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
              Text(
                title,
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
