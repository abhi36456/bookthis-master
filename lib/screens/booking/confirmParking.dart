import 'dart:async';
import 'dart:convert';

import 'package:bookthis/models/amenity.dart';
import 'package:bookthis/models/building.dart';
import 'package:bookthis/utils/api.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/heading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ConfirmParking extends StatefulWidget {
  final Map<String, dynamic> data;

  ConfirmParking(this.data);

  @override
  _ConfirmParkingState createState() => _ConfirmParkingState();
}

class _ConfirmParkingState extends State<ConfirmParking> {
  List<Amenity> amenities;
  Building building;
  setData() {
    amenities = widget.data["amenities"] as List<Amenity>;
    building = widget.data["building"] as Building;
    print(amenities);
    print(building);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: AppColors.primaryColor),
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/confirmParking.png",
                height: 200,
                width: 200,
              )),
          Positioned(
            bottom: 0,
            child: Container(
              height: 486,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          building.buildingName,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Divider(
                          color: AppColors.borderColor,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy")
                                    .format(widget.data["date"]),
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColors.borderColor,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text(
                                DateFormat()
                                        .add_jm()
                                        .format(widget.data["fromTime"]) +
                                    " - " +
                                    DateFormat()
                                        .add_jm()
                                        .format(widget.data["toTime"]),
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: AppColors.borderColor,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Amenities",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: amenities
                              .map(
                                (e) => Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    e.amneties,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                        fontSize: 12),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      height: 85,
                      width: double.infinity,
                      color: AppColors.primaryColor,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bookthis ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      book(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void book(context) async {
    try {
      var amenitiesId = [];
      amenities.forEach((element) {
        amenitiesId.add(element.id);
      });
      Response response = await ApiCall.post(
          "booking.php",
          {
            "building_id": building.id,
            "type": "parking",
            "amneties": amenitiesId.join(','),
            "date": DateFormat("yyyy-MM-dd").format(widget.data["date"]),
            "from_time": DateFormat("hh:mm").format(widget.data["fromTime"]),
            "to_time": DateFormat("hh:mm").format(widget.data["toTime"])
          },
          auth: true);
      var data = jsonDecode(response.data);
      if (data["status"]) {
        BuildContext dialogContext;
        Timer(Duration(seconds: 1), () {
          Navigator.pop(dialogContext);
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        showDialog(
            context: context,
            builder: (ctx) {
              dialogContext = ctx;
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                scrollable: true,
                content: Column(
                  children: [
                    Image.asset("assets/images/booked.png"),
                    SizedBox(
                      height: 10,
                    ),
                    Heading(
                      text: "Booked!",
                    ),
                  ],
                ),
              );
            });
      } else {
        Fluttertoast.showToast(msg: data["message"]);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }
}
