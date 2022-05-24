import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:d_chart/d_chart.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:table_calendar/table_calendar.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/common/line_chart_sample_2.dart';
import 'package:training_app/common/utils.dart';
import 'package:training_app/models/training_date_model.dart';
import 'package:training_app/pages/user/test2.dart';
import 'daily_training.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:smoothie/smoothie.dart';

class MonthlyOverview extends StatefulWidget {
  Map<DateTime,String> toHighlight;
  MonthlyOverview(this.toHighlight);

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
  int trainingTime = 0;
  final List<ChartData> chartData = [
    ChartData(2010, 35),
    ChartData(2011, 13),
    ChartData(2012, 34),
    ChartData(2013, 27),
    ChartData(2014, 40)
  ];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;//"2022-04-11"
  String dateForGraph = DateFormat('yyyy-MM-dd').format(DateTime.now());


  getCircledDate()async{
    String userId = await CommonMethods.getUserId();
    Response myRes = await CommonMethods.commonGetApiData(ApiInterface.TRAINING_DATES+userId);
    TrainingDateModel dates = trainingDateModelFromJson(myRes.data);
    List<TrainingDateDatum> listData = dates.data;
    widget.toHighlight.clear();
    for(int i=0;i<listData.length;i++){
      widget.toHighlight[listData[i].dates] = listData[i].isUpdate;
    }
    setState(() {

    });
  }


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
    // TODO: implement initState
    super.initState();
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(List<TimeSeriesSales> mData) {
    // final data = [
    //   TimeSeriesSales(DateTime(2017, 9, 19), 5),
    //   TimeSeriesSales(DateTime(2017, 9, 26), 25),
    //   TimeSeriesSales(DateTime(2017, 10, 3), 120),
    //   TimeSeriesSales(DateTime(2017, 10, 10), 75),
    // ];

    final data = mData;
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        seriesColor: charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        // When the measureLowerBoundFn and measureUpperBoundFn is defined,
        // the line renderer will render the area around the bounds.
        measureLowerBoundFn: (TimeSeriesSales sales, _) => sales.sales - 5,
        measureUpperBoundFn: (TimeSeriesSales sales, _) => sales.sales + 5,
        data: data,
      )
    ];
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
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      for (DateTime d in widget.toHighlight.keys) {
                        if (day.day == d.day &&
                            day.month == d.month &&
                            day.year == d.year) {
                          return Container(
                            decoration: BoxDecoration(
                              color: widget.toHighlight[d]=='0'?Colors.transparent:CommonVar.RED_BUTTON_COLOR,
                              border: Border.all(color: widget.toHighlight[d]=='0'?CommonVar.RED_BUTTON_COLOR:Colors.transparent),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }
                      return null;
                    },
                  ),
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
                      Get.to(DailyTraining(_selectedDay!))!.then((value){
                        setState(() {
                          getCircledDate();
                        });
                      });
                    }
                    else{
                      _selectedDay = selectedDay;
                      Get.to(DailyTraining(_selectedDay!))!.then((value){
                        setState(() {
                          getCircledDate();
                        });
                      });
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
                    dateForGraph = DateFormat('yyyy-MM-dd').format(_focusedDay);
                    setState(() {

                    });
                  },

                ),
              ),
              FutureBuilder(
                future: CommonMethods.getUserId(),
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return const Text('Loading..');
                  }
                  else{
                    String userId = snapshot.data as String;
                    Map sendMap = {"user_date" : dateForGraph};
                    return FutureBuilder(
                      future: CommonMethods.commonPostApiData(ApiInterface.GRAPH_DATES+userId, sendMap),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(
                                  value: 0.8,
                                ),
                                const SizedBox(height: 10.0,),
                                Text('Loading...',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white
                                  ),)
                              ],
                            ),
                          );
                        }
                        else{
                          Response myRes = snapshot.data as Response;
                          Map myMap = json.decode(myRes.data);
                          if(myMap['data'].runtimeType == bool){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                              child: CommonWidgets.commonButton('Training time in this month\n0 minutes', () { },iconData: Icons.motorcycle),
                            );
                          }
                          else{
                            int timeInt = 0;
                            TrainingDateModel dates = trainingDateModelFromJson(myRes.data);
                            List<TrainingDateDatum> listData = dates.data;
                            List<Map<String, dynamic>> showVal = [];
                            for(int i=0;i<listData.length;i++){
                              timeInt = timeInt+int.parse(listData[i].totalRainingstime);
                              Map<String, dynamic> myMap = {'domain' : DateFormat('dd MMM').format(listData[i].dates), 'measure' : int.parse(listData[i].totalRainingstime)};
                              showVal.add(myMap);
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                              child: CommonWidgets.commonButton('Training time in this month\n'+timeInt.toString()+ ' minutes', () { },iconData: Icons.motorcycle),
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
              Container(
                  height: 200.0,
                  width: 200.0,
                  child: FutureBuilder(
                    future: CommonMethods.getUserId(),
                    builder: (context, snapshot){
                      if(snapshot.data == null){
                        return const Text('Loading..');
                      }
                      else{
                        String userId = snapshot.data as String;
                        Map sendMap = {"user_date" : dateForGraph};
                        return FutureBuilder(
                          future: CommonMethods.commonPostApiData(ApiInterface.GRAPH_DATES+userId, sendMap),
                          builder: (context, snapshot){
                            if(snapshot.data == null){
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      value: 0.8,
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text('Loading...',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white
                                      ),)
                                  ],
                                ),
                              );
                            }
                            else{
                              Response myRes = snapshot.data as Response;
                              Map myMap = json.decode(myRes.data);
                              if(myMap['data'].runtimeType == bool){
                                return SizedBox(
                                    child: Center(
                                      child: Text(
                                        'No training data found',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20.0
                                        ),
                                      ),
                                    )
                                );
                              }
                              else{
                                TrainingDateModel dates = trainingDateModelFromJson(myRes.data);
                                List<TrainingDateDatum> listData = dates.data;
                                List<Map<String, dynamic>> showVal = [];
                                // TimeSeriesSales(DateTime(2017, 9, 19), 5),
                                List<FlSpot> mFlSpot = [];
                                List<TimeSeriesSales> mData = [];
                                for(int i=0;i<listData.length;i++){
                                  Map<String, dynamic> myMap = {'domain' : int.parse(DateFormat('dd').format(listData[i].dates)), 'measure' : int.parse(listData[i].totalRainingstime)};
                                  showVal.add(myMap);
                                  FlSpot mm = FlSpot(double.parse(DateFormat('dd').format(listData[i].dates)), double.parse(listData[i].totalRainingstime));
                                  mFlSpot.add(mm);
                                  TimeSeriesSales tss = TimeSeriesSales(listData[i].dates,int.parse(listData[i].totalRainingstime));
                                  mData.add(tss);
                                }
                                // return TimeSeriesLineAnnotationChart(_createSampleData(mData));
                                return LineChartSample2(mFlSpot);
                                // return DChartLine(
                                //   data: [
                                //     {
                                //       'id': 'Bar',
                                //       'data': showVal,
                                //     },
                                //   ],
                                //   lineColor: (lineData, index, id) => CommonVar.RED_BUTTON_COLOR,
                                //   includePoints: true,
                                  // domainLabelPaddingToAxisLine: 16,
                                  // axisLineTick: 2,
                                  // axisLinePointTick: 2,
                                  // axisLinePointWidth: 8,
                                  // axisLineColor: CommonVar.RED_BUTTON_COLOR,
                                  // measureLabelPaddingToAxisLine: 16,
                                  // barColor: (barData, index, id) => CommonVar.RED_BUTTON_COLOR,
                                  // barValue: (barData, index) => '${barData['measure']}',
                                  // barValueColor: Colors.white,
                                  // showBarValue: true,
                                  // barValuePosition: BarValuePosition.auto,
                                  // measureLabelColor: Colors.white,
                                  // domainLabelColor: Colors.white, lineColor: (Map<String, dynamic> lineData, int? index, String id) {  },
                              }
                            }
                          },
                        );
                      }
                    },
                  ),
                  // child: LLineChart(myList)
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