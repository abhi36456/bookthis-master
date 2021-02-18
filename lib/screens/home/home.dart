import 'package:bookthis/screens/booking/book_desk.dart';
import 'package:bookthis/screens/booking/when.dart';
import 'package:bookthis/screens/home/widgets/booking_card.dart';
import 'package:bookthis/screens/login/login.dart';
import 'package:bookthis/screens/my_bookings/my_bookings.dart';
import 'package:bookthis/screens/profile/profile.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String profile = "";
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      profile = prefs.getString("profile");
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Book this",
      drawer: Drawer(
        child: Container(
          color: AppColors.primaryColor,
          padding: EdgeInsets.only(top: kToolbarHeight, left: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: profile != null && profile.isNotEmpty
                          ? NetworkImage(profile)
                          : AssetImage("assets/images/user.png"),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => Profile()))
                      .then((value) {
                    if (value != null && value) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => Login()));
                    }
                  });
                },
              ),
              ListTile(
                title: Text(
                  "My bookings",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MyBookings()));
                },
              ),
            ],
          ),
        ),
      ),
      child: Column(
        children: [
          BookingCard(
            image: "desk.png",
            title: "Desk/Seat",
            subTitle: "Book a desk",
            onPressed: navigateDesk,
          ),
          SizedBox(
            height: 20,
          ),
          BookingCard(
            image: "parking.png",
            title: "Parking",
            subTitle: "Reserve a parking",
            onPressed: navigateParking,
          ),
        ],
      ),
    );
  }

  void navigateDesk() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookDesk()));
  }

  void navigateParking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => When(details: {"type": "parking"}),
      ),
    );
  }
}
