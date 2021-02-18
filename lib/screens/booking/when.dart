import 'package:bookthis/screens/booking/where_desk.dart';
import 'package:bookthis/screens/booking/where_parking.dart';
import 'package:bookthis/utils/app_colors.dart';
import 'package:bookthis/widgets/custom_page.dart';
import 'package:bookthis/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class When extends StatefulWidget {
  final Map details;

  When({@required this.details});

  @override
  _WhenState createState() => _WhenState();
}

class _WhenState extends State<When> {
  CalendarController _calendarController;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(minutes: 15));
  bool showFromSelector = false;
  bool showToSelector = false;
  bool allDay = false;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "When?",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Heading(
            text: "Time",
          ),
          IgnorePointer(
            ignoring: allDay,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 7),
                          decoration: BoxDecoration(
                            color: showFromSelector
                                ? Color(0xFFECEAFE)
                                : Colors.transparent,
                            border: Border.all(
                                color: showFromSelector
                                    ? AppColors.primaryColor
                                    : AppColors.borderColor),
                            // border: Border.all(color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fromDate.hour.toString().padLeft(2, "0") +
                                    ":" +
                                    fromDate.minute.toString().padLeft(2, "0"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: !allDay
                                      ? AppColors.primaryColor
                                      : AppColors.borderColor,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.borderColor,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showToSelector = false;
                            showFromSelector = !showFromSelector;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 7),
                          decoration: BoxDecoration(
                              color: showToSelector
                                  ? Color(0xFFECEAFE)
                                  : Colors.transparent,
                              border: Border.all(
                                  color: showToSelector
                                      ? AppColors.primaryColor
                                      : AppColors.borderColor),
                              borderRadius: BorderRadius.circular(10)),
                          // alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                toDate.hour.toString().padLeft(2, "0") +
                                    ":" +
                                    toDate.minute.toString().padLeft(2, "0"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: !allDay
                                      ? AppColors.primaryColor
                                      : AppColors.borderColor,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.borderColor,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showFromSelector = false;
                            showToSelector = !showToSelector;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          showFromSelector || showToSelector
              ? TimePickerWidget(
                  dateFormat: "HH mm",
                  initDateTime: showFromSelector ? fromDate : toDate,
                  onChange: (date, _) {
                    setState(() {
                      if (showFromSelector) {
                        fromDate = date;
                        toDate = fromDate.add(Duration(minutes: 15));
                      } else if (showToSelector) toDate = date;
                    });
                  },
                  minuteDivider: 15,
                  pickerTheme: DateTimePickerTheme(
                    showTitle: false,
                    itemTextStyle: TextStyle(fontSize: 20),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        "All day",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Switch(
                        value: allDay,
                        onChanged: (val) {
                          setState(() {
                            showFromSelector = false;
                            showToSelector = false;
                            allDay = !allDay;
                          });
                        },
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 15,
          ),
          Heading(
            text: "Date",
          ),
          TableCalendar(
            calendarController: _calendarController,
            availableCalendarFormats: {CalendarFormat.month: "Month"},
            builders: CalendarBuilders(
                selectedDayBuilder: (ctx, date, selectedDayBuilder) {
              return Container(
                color: AppColors.primaryColor,
                child: Center(
                    child: Text(
                  date.day.toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              );
            }),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextBuilder: (date, _) {
                var days = {
                  1: "M",
                  2: "T",
                  3: "W",
                  4: "T",
                  5: "F",
                  6: "S",
                  7: "S"
                };
                return days[date.weekday];
              },
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.black),
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              titleTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              titleTextBuilder: (date, _) {
                var months = {
                  1: "Jan",
                  2: "Feb",
                  3: "Mar",
                  4: "Apr",
                  5: "May",
                  6: "Jun",
                  7: "Jul",
                  8: "Aug",
                  9: "Sep",
                  10: "Oct",
                  11: "Nov",
                  12: "Dec",
                };
                return months[date.month] + " " + date.year.toString();
              },
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColors.primaryColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColors.primaryColor,
              ),
            ),
            startDay: DateTime.now(),
            calendarStyle: CalendarStyle(
              highlightToday: false,
              contentDecoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 0.5,
                ),
              ),
              selectedStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              selectedColor: AppColors.primaryColor,
              weekdayStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              weekendStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 52,
          ),
        ],
      ),
      actionButton: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text("Next"),
          onPressed: () {
            if (allDay) {
              fromDate = DateTime.now();
              toDate = fromDate.add(Duration(hours: 12));
            }
            Map data = widget.details;
            data.addAll({
              "date": _calendarController.selectedDay,
              "fromTime": fromDate,
              "toTime": toDate
            });
            if (data["type"] == "desk")
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WhereDesk(details: data),
                ),
              );
            else
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WhereParking(data),
                ),
              );
          },
        ),
      ),
    );
  }
}
