import 'package:d_chart/d_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("widget"),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("widget"),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("widget"),
            )
          ],
        ),
      ),
    );
  }
}