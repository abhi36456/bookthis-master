import 'dart:convert';

import 'package:bookthis/models/amenity.dart';
import 'package:bookthis/models/building.dart';
import 'package:bookthis/utils/api.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:bookthis/widgets/heading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'confirmParking.dart';

class WhereParking extends StatefulWidget {
  final Map data;

  WhereParking(this.data);

  @override
  _WhereParkingState createState() => _WhereParkingState();
}

class _WhereParkingState extends State<WhereParking> {
  List<Building> _buildings = [];
  List<Amenity> _amenities = [];
  List<Amenity> selectedAmenities = [];
  Building selectedBuilding;
  getData(function) async {
    BuildContext loadContext;
    showDialog(
      context: context,
      builder: (ctx) {
        loadContext = ctx;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 50,
                  width: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
    await function();
    Navigator.pop(loadContext);
  }

  getBuildings() async {
    _buildings.clear();
    try {
      Response response = await ApiCall.get("get_building.php");
      var data = jsonDecode(response.data);
      setState(() {
        data["data"].forEach((e) {
          _buildings.add(Building.fromJson(e));
        });
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  getAmenities() async {
    print("Called");
    _amenities.clear();
    try {
      Response response = await ApiCall.post(
          "get_parking_amneties.php", {"building_id": selectedBuilding.id});
      var data = jsonDecode(response.data);
      setState(() {
        data["data"].forEach((e) {
          _amenities.add(Amenity.fromJson(e));
        });
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  int selector = -1;
  void select(i) {
    getAmenities();
    setState(() {
      if (selector == i) {
        selector = -1;
      } else
        selector = i;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => getData(getBuildings));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Where",
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedBuilding?.buildingName ?? "Building",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: selectedBuilding != null
                            ? AppColors.primaryColor
                            : Colors.black),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.borderColor,
                  ),
                ],
              ),
            ),
            onTap: () {
              if (selectedBuilding == null) selectedBuilding = _buildings[0];
              select(0);
            },
          ),
          selector != -1
              ? Container(
                  height: 250,
                  child: CupertinoPicker.builder(
                    key: ValueKey(selector),
                    itemExtent: 32,
                    itemBuilder: (ctx, index) {
                      return Text(_buildings[index].buildingName);
                    },
                    childCount: _buildings.length,
                    onSelectedItemChanged: (i) {
                      setState(() {
                        selectedBuilding = _buildings[i];
                      });
                    },
                    // magnification: 1.5,
                  ),
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          _amenities.isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Heading(
                    text: "Amenities",
                  ),
                )
              : Container(),
          _amenities.isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: _amenities
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedAmenities.contains(e))
                                  selectedAmenities.remove(e);
                                else
                                  selectedAmenities.add(e);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                e.amneties,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedAmenities.contains(e)
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                    height: 1.2,
                                    fontSize: 16),
                              ),
                              decoration: BoxDecoration(
                                color: selectedAmenities.contains(e)
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(),
        ],
      ),
      actionButton: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text("Next"),
          onPressed: selectedBuilding != null ? book : null,
        ),
      ),
    );
  }

  book() {
    Map<String, dynamic> data = Map.from(widget.data);
    data["building"] = selectedBuilding;
    data["amenities"] = selectedAmenities;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ConfirmParking(data)));
  }
}
