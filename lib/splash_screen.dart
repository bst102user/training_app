import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/pages/trainer/tr_dashboard.dart';
import 'package:training_app/pages/user/login_page.dart';
import 'package:training_app/pages/user/nav_dashboard.dart';

class SplashScreen extends StatefulWidget{
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  goToNextScreen()async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    bool snapshot = mPref.getBool('is_login') as bool;
    String userType = mPref.getString('user_type') as String;
    Future.delayed(const Duration(seconds: 3), () {
      if(snapshot == null){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
      }
      else {
        if (!snapshot) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
        }
        else {
          if(userType == 'Trainer'){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => TrDashboard()),
                    (Route<dynamic> route) => false);
          }
          else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => NavDashboard()),
                    (Route<dynamic> route) => false);
          }
        }
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToNextScreen();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/load_icon.png'),
          )
        ],
      ),
    );
  }
  
}