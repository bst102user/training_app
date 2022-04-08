import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_app/provider_ex/timer_data.dart';

class ProHome extends StatefulWidget{

  @override
  ProHomeState createState(){
    return ProHomeState();
  }
}

class ProHomeState extends State<ProHome>{
  var remaining = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remaining--;
      });
      if(timer == 0){
        timer.cancel();
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      var timerInfo = Provider.of<TimerData>(context,listen: false);
      timerInfo.updateRemainingTime();
      print(timerInfo.getRemainProvider());
      if(timerInfo.getRemainProvider() == 0){
        timer.cancel();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

    );
  }

}