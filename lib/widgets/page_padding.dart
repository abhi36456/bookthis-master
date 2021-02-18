import 'package:flutter/material.dart';

class PagePadding extends StatelessWidget {
  final child;

  PagePadding({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: child,
    );
  }
}
