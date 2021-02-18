import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/page_padding.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  final String title;
  final Widget drawer;
  final Widget child;
  final Widget actionButton;
  final Widget appBarAction;
  final bool giveTopPadding;
  CustomPage(
      {@required this.title,
      this.drawer,
      @required this.child,
      this.actionButton,
      this.appBarAction,
      this.giveTopPadding = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        toolbarHeight: kToolbarHeight + 20,
        centerTitle: true,
        elevation: 0,
        actions: [appBarAction ?? Container()],
      ),
      drawer: drawer,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: PagePadding(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: giveTopPadding ? kToolbarHeight : 0),
            child: child,
          ),
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: actionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
