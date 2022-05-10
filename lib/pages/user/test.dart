import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_app/models/training_date_model.dart';

class LLineChart extends StatelessWidget {
  // final List<String> mySide1;
  // final List<String> myBottomVal;
  // final List<double> realValues;
  // LLineChart(this.mySide1, this.myBottomVal, this.realValues);
  List<TrainingDateDatum> listData;
  LLineChart(this.listData);

  // final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      myRealData(),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData myRealData(){
    return LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: sideTile(),
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData sideTile(){
    return FlTitlesData(
      bottomTitles: bottomTime(),
      leftTitles: leftTitles(
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return listData[0].totalRainingstime;
            case 2:
              return listData[1].totalRainingstime;;
            case 3:
              return listData[2].totalRainingstime;;
          }
          return '';
        },
      ),
    );
  }

  List<LineChartBarData> get lineBarsData1 => [
    lineTest(),
  ];



  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
    getTitles: getTitles,
    showTitles: true,
    margin: 8,
    interval: 1,
    reservedSize: 40,
    getTextStyles: (context, value) => const TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );

  SideTitles bottomTime(){
    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      margin: 10,
      interval: 1,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff72719b),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      getTitles: (value) {
        switch (value.toInt()) {
          case 2:
            return DateFormat('dd MMM').format(listData[0].dates);//listData[0].dates;
          case 7:
            return DateFormat('dd MMM').format(listData[1].dates);
          case 12:
            return DateFormat('dd MMM').format(listData[2].dates);
        }
        return '';
      },
    );
  }

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 4),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData lineTest(){
    return LineChartBarData(
      isCurved: true,
      colors: [const Color(0xff4af699)],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots:  [
        FlSpot(1, double.parse(listData[0].totalRainingstime)/100),
        FlSpot(2, double.parse(listData[1].totalRainingstime)/100),
        FlSpot(3, double.parse(listData[2].totalRainingstime)/100),
      ],
    );
  }

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //   isCurved: true,
  //   colors: [const Color(0xff4af699)],
  //   barWidth: 1,
  //   isStrokeCapRound: true,
  //   dotData: FlDotData(show: false),
  //   belowBarData: BarAreaData(show: false),
  //   spots: const [
  //     FlSpot(1, 1),
  //     FlSpot(3, 1.5),
  //     FlSpot(5, 1.4),
  //   ],
  // );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const Text(
                  'Unfold Shop 2018',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Monthly Sales',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}