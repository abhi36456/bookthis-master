import 'dart:async';
import 'dart:convert';

import 'package:bookthis/screens/home/home.dart';
import 'package:bookthis/utils/api.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/page_padding.dart';
import 'package:bookthis/widgets/tc_and_policy.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagePadding(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                  Text(
                    "Please log in with your work email",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Enter Email";
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Enter Psssword";
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 20),
                    ),
                    onPressed: forgotPassword,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: Text("Log In"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TcAndPolicy(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void forgotPassword() {
    showDialog(
        context: context,
        builder: (ctx) {
          final emailController = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text(
              "Forgot Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              children: [
                Text("Enter your email"),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "example@email.com"),
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.primaryColor),
                  )),
              FlatButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter email");
                    } else {
                      try {
                        Response response =
                            await ApiCall.post("forgot_password.php", {
                          "email": emailController.text.trim(),
                        });
                        var data = jsonDecode(response.data);
                        print(data);
                        if (data["status"]) {
                          Fluttertoast.showToast(msg: data["message"]);
                          Navigator.pop(ctx);
                        } else {
                          Fluttertoast.showToast(msg: data["message"]);
                        }
                      } catch (e) {
                        print(e);
                        Navigator.pop(ctx);
                        Fluttertoast.showToast(msg: "Something went wrong");
                      }
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: AppColors.primaryColor),
                  )),
            ],
          );
        });
  }

  void login(context) async {
    if (_formKey.currentState.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      try {
        Response response = await ApiCall.post("login.php",
            {"email": email, "password": password, "device_type": "A"});
        var data = jsonDecode(response.data);
        print(data);
        if (data["status"]) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("id", data["data"]["id"]);
          prefs.setString("name", data["data"]["full_name"]);
          prefs.setString("profile", data["data"]["profile_pic"]);
          prefs.setString("email", data["data"]["email"]);
          prefs.setString("country", data["data"]["country"]);
          prefs.setString("city", data["data"]["city"]);
          prefs.setString("token", data["data"]["auth_key"]);
          BuildContext dialogContext;
          Timer(Duration(seconds: 2), () {
            Navigator.pop(dialogContext);
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                dialogContext = ctx;
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Color(0xFF000C2B),
                    title: CircleAvatar(
                      backgroundImage: data["data"]["profile_pic"].isNotEmpty
                          ? NetworkImage(data["data"]["profile_pic"])
                          : null,
                      minRadius: 75,
                      maxRadius: 75,
                    ),
                    content: Text(
                      "Welcome\n${data["data"]["full_name"].split(" ")[0]}!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                );
              });
        } else {
          Fluttertoast.showToast(msg: data["message"]);
        }
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    }
  }
}
