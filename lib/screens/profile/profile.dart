import 'dart:io' show Platform;

import 'package:bookthis/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pop(context, true);
  }

  logoutConf(context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          Widget title = Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
          return Platform.isAndroid
              ? AlertDialog(
                  title: title,
                  actions: [
                    FlatButton(
                      child:
                          Text("Cancel", style: TextStyle(color: Colors.black)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        logout();
                      },
                    ),
                  ],
                )
              : CupertinoAlertDialog(
                  title: title,
                  actions: [
                    FlatButton(
                      child:
                          Text("Cancel", style: TextStyle(color: Colors.black)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        logout();
                      },
                    ),
                  ],
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          FlatButton(
            child: Text("Log Out",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
            onPressed: () {
              logoutConf(context);
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            var data = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: data.getString("profile") != null &&
                                data.getString("profile").isNotEmpty
                            ? NetworkImage(data.getString("profile"))
                            : AssetImage("assets/images/user.png"),
                        radius: 36,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.getString("name"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          data.getString("city").isEmpty ||
                                  data.getString("country").isEmpty
                              ? Container()
                              : Text(
                                  "${data.getString("city")}, ${data.getString("country")}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.getString("email"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
