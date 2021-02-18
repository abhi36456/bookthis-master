import 'dart:convert';

import 'package:bookthis/models/amenity.dart';
import 'package:bookthis/models/building.dart';
import 'package:bookthis/models/floor.dart';
import 'package:bookthis/models/section.dart';
import 'package:bookthis/screens/booking/confirm_desk.dart';
import 'package:bookthis/utils/api.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:bookthis/widgets/heading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WhereDesk extends StatefulWidget {
  final Map details;

  WhereDesk({this.details});

  @override
  _WhereDeskState createState() => _WhereDeskState();
}

class _WhereDeskState extends State<WhereDesk> {
  List<Building> _buildings = [];
  List<Floor> _floors = [];
  List<Section> _sections = [];
  List<Amenity> _amenities = [];
  List<Amenity> selectedAmenities = [];
  int selector = -1;
  Building selectedBuilding;
  Floor selectedFloor;
  Section selectedSection;
  var displayList = [];
  void select(i) {
    setState(() {
      if (selector == 0) {
        print("SELECTOR");
        getAmenities();
      }
      if (selector == i) {
        selector = -1;
      } else
        selector = i;
    });
  }

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

  getFloors() async {
    _floors.clear();
    try {
      Response response = await ApiCall.post(
          "get_building_floor.php", {"building_id": selectedBuilding.id});
      var data = jsonDecode(response.data);
      setState(() {
        data["data"].forEach((e) {
          _floors.add(Floor.fromJson(e));
        });
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  getSections() async {
    _sections.clear();
    try {
      Response response = await ApiCall.post("get_building_section.php",
          {"building_id": selectedBuilding.id, "floor_id": selectedFloor.id});
      var data = jsonDecode(response.data);
      setState(() {
        data["data"].forEach((e) {
          _sections.add(Section.fromJson(e));
        });
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    }
  }

  getAmenities() async {
    _amenities.clear();
    try {
      Response response = await ApiCall.post(
          "get_desk_amneties.php", {"building_id": selectedBuilding.id});
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
            onTap: () async {
              if (selectedBuilding == null) selectedBuilding = _buildings[0];
              select(0);
            },
          ),
          SizedBox(
            height: 20,
          ),
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
                    selectedFloor?.floorName ?? "Floor",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: selectedFloor != null
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
            onTap: () async {
              if (selectedBuilding != null) {
                await getData(getFloors);
                selectedFloor = _floors[0];
                select(1);
              } else
                Fluttertoast.showToast(msg: "Select Building!");
            },
          ),
          SizedBox(
            height: 20,
          ),
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
                    selectedSection?.sectionName ?? "Section",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: selectedSection != null
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
            onTap: () async {
              if (selectedFloor != null) {
                await getData(getSections);
                selectedSection = _sections[0];
                select(2);
              } else
                Fluttertoast.showToast(msg: "Select Floor!");
            },
          ),
          selector != -1
              ? Container(
                  height: 250,
                  child: CupertinoPicker.builder(
                    key: ValueKey(selector),
                    itemExtent: 32,
                    itemBuilder: (ctx, index) {
                      return Text(selector == 0
                          ? _buildings[index].buildingName
                          : selector == 1
                              ? _floors[index].floorName
                              : _sections[index].sectionName);
                    },
                    childCount: selector == 0
                        ? _buildings.length
                        : selector == 1
                            ? _floors.length
                            : _sections.length,
                    onSelectedItemChanged: (i) {
                      setState(() {
                        if (selector == 0)
                          selectedBuilding = _buildings[i];
                        else if (selector == 1)
                          selectedFloor = _floors[i];
                        else
                          selectedSection = _sections[i];
                      });
                    },
                    // magnification: 1.5,
                  ),
                )
              : Container(),
          _amenities.isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Heading(
                    text: "Amenities",
                  ),
                )
              : Container(),
          SizedBox(
            height: 5,
          ),
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
          onPressed: selectedSection != null &&
                  selectedFloor != null &&
                  selectedBuilding != null
              ? book
              : null,
        ),
      ),
    );
  }

  book() {
    Map<String, dynamic> data = Map.from(widget.details);
    data["building"] = selectedBuilding;
    data["section"] = selectedSection;
    data["floor"] = selectedFloor;
    data["amenities"] = selectedAmenities;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ConfirmDesk(data)));
  }
}
