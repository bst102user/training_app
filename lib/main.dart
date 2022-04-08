import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/pages/user/login_page.dart';
import 'package:training_app/splash_screen.dart';
import 'pages/user/nav_dashboard.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
      home: SplashScreen(),
      // home: FutureBuilder(
      //   future: CommonMethods.getBoolPref('is_login'),
      //   builder: (context, snapshot){
      //     bool isLogin = snapshot.data as bool;
      //     if(snapshot.data == null){
      //       return LoginPage();
      //     }
      //     else {
      //       if (!isLogin) {
      //         return LoginPage();
      //       }
      //       else {
      //         return NavDashboard();
      //       }
      //     }
      //   },
      // ),
    );
  }
}
