import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/pages/add_race.dart';
import 'package:training_app/pages/daily_training.dart';
import 'package:training_app/pages/login_page.dart';
import 'package:training_app/pages/nav_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: CommonMethods.getBoolPref('is_login'),
        builder: (context, snapshot){
          bool isLogin = snapshot.data as bool;
          if(snapshot.data == null || !isLogin){
            return NavDashboard();
          }
          else{
            return NavDashboard();
          }
        },
      ),
    );
  }
}
