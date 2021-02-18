import 'dart:convert';
import 'dart:io' show Platform;

import 'package:bookthis/models/bookings.dart';
import 'package:bookthis/utils/api.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  Bookings bookings;
  bool isEdit = false;
  getBookings() async {
    try {
      Response response = await ApiCall.post("get_booking.php", {}, auth: true);
      setState(() {
        bookings = Bookings.fromJson(jsonDecode(response.data));
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  deleteBooking(Data booking) async {
    try {
      Response response = await ApiCall.post(
          "delete_booking.php", {"booking_id": booking.id},
          auth: true);
      print(response.data);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  delete(Data booking, context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          Widget title = Text(
            "Delete this booking?",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
          Widget deleteBtn = FlatButton(
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await deleteBooking(booking);
              Navigator.pop(context);
              getBookings();
            },
          );
          return Platform.isAndroid
              ? AlertDialog(
                  title: title,
                  actions: [
                    deleteBtn,
                  ],
                )
              : CupertinoAlertDialog(
                  title: title,
                  actions: [
                    deleteBtn,
                  ],
                );
        });
  }

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "My Bookings",
      child: bookings == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: bookings.bookings
                  .map((e) => Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 32,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.buildingName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      e.address,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    e.type == "desk"
                                        ? Text(
                                            "Floor ${e.floorName} section ${e.sectionName}",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${e.fromTime} - ${e.toTime}",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            DateFormat("dd/MM/yyyy")
                                                .format(e.date),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              isEdit
                                  ? GestureDetector(
                                      child: Image.asset(
                                        "assets/images/delete.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                      onTap: () {
                                        delete(e, context);
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            color: AppColors.borderColor,
                          )
                        ],
                      ))
                  .toList(),
            ),
      appBarAction: FlatButton(
          child: Text(
            isEdit ? "Done" : "Edit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              isEdit = !isEdit;
            });
          }),
    );
  }
}
