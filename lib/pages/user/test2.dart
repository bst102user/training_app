import 'package:d_chart/d_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: DChartBar(
          data: [
            {
              'id': 'Bar',
              'data': [
                {'domain': '2020', 'measure': 3},
                {'domain': '2021', 'measure': 4},
                {'domain': '2022', 'measure': 6},
                {'domain': '2023', 'measure': 0.3},
              ],
            },
          ],
          domainLabelPaddingToAxisLine: 16,
          axisLineTick: 2,
          axisLinePointTick: 2,
          axisLinePointWidth: 8,
          axisLineColor: Colors.green,
          measureLabelPaddingToAxisLine: 16,
          barColor: (barData, index, id) => barData['measure'] >= 4
              ? Colors.green.shade300
              : Colors.green.shade700,
          barValue: (barData, index) => '${barData['measure']}',
          showBarValue: true,
          barValuePosition: BarValuePosition.auto,
        ),
      ),
    );
  }
}