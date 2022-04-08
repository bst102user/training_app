import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:table_calendar/table_calendar.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/common/utils.dart';
import 'daily_training.dart';
import 'racing_calender.dart';
import 'test.dart';

class MonthlyOverview extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  MonthlyOverviewState createState() => new MonthlyOverviewState();
}

class MonthlyOverviewState extends State<MonthlyOverview> {
  final List<ChartData> chartData = [
    ChartData(2010, 35),
    ChartData(2011, 13),
    ChartData(2012, 34),
    ChartData(2013, 27),
    ChartData(2014, 40)
  ];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;



  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime(2022, 1, 31));
  DateTime _targetDateTime = DateTime(2055, 1, 31);
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/cycle_run.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0,left: 20.0),
                child: CommonWidgets.commonHeader(context, 'monthly overview'),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: TableCalendar(
                  headerStyle: HeaderStyle(
                    titleTextStyle: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600
                    ),
                    rightChevronIcon: const Icon(
                        Icons.arrow_right_outlined,
                      color: Colors.white,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.arrow_left_outlined,
                      color: Colors.white,
                    )
                  ),
                  firstDay: kFirstDay,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.roboto(
                      color: Colors.white
                    ),
                    weekendStyle: GoogleFonts.roboto(
                        color: Colors.white
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: GoogleFonts.roboto(
                        color: Colors.white
                    ),
                    weekendTextStyle: GoogleFonts.roboto(
                        color: Colors.white
                    ),
                  ),
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {

                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      print(_selectedDay);
                      // String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);
                      Get.to(DailyTraining(_selectedDay!));
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child: CommonWidgets.commonButton('Training time in this month\n120 hours', () { },iconData: Icons.motorcycle),
              ),
              Container(
                  height: 200.0,
                  width: 200.0,
                  child: LLineChart(isShowingMainData: true)
              )//
            ],
          ),
        )
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}