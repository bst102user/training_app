import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/methods.dart';
import 'package:training_app/firebase/screens/home_screen.dart';
import 'package:training_app/pages/trainer/export_page.dart';
import 'package:training_app/pages/trainer/notification_trainer.dart';
import 'package:training_app/pages/trainer/tr_assgn_athletes_page.dart';
import 'package:training_app/pages/user/login_page.dart';

class TrDashboard extends StatefulWidget{
  TrDashboardState createState() => TrDashboardState();
}

class TrDashboardState extends State<TrDashboard>{
  initState(){
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
    });
  }
  Widget commonView(IconData mIcon, String label, {mCallback}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return InkWell(
      onTap: mCallback,
      child: Container(
        height: 70.0,
        decoration: const BoxDecoration(
          border: Border(
            bottom: borderSide,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  mIcon,
                  size: 30.0,
                  color: Colors.white,
                ),
                const SizedBox(width: 15.0,),
                Text(
                  label,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/tr_back.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: ListView(
            children: [
              Text(
                'Account'.toUpperCase(),
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600
                ),
              ),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView(Icons.person, 'List Athlets',mCallback: (){
                Get.to(TrAssgnAthletesPage());
              }),
              commonView(Icons.notifications_rounded, 'Notification', mCallback: (){
                Get.to(NotificationTrainer());
              }),
              commonView(Icons.chat_bubble, 'Messenger',mCallback: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen())
                );
              }),
              commonView(Icons.logout, 'Logout',mCallback: ()async{
                CommonMethods.twoButtonDialoge(context, 'Logout', 'Would you like to logout from the Application?',(){
                  logOut(context).then((value){
                    CommonMethods.saveStrPref('profile_fullpath', '');
                    CommonMethods.saveStrPref('trainer_id', '0');
                    CommonMethods.saveStrPref('user_id', '');
                    CommonMethods.saveStrPref('user_email', '');
                    CommonMethods.saveStrPref('user_fname', '');
                    CommonMethods.saveStrPref('user_lname', '');
                    CommonMethods.saveStrPref('trainer_id', '');
                    CommonMethods.saveStrPref('user_type', '');
                    CommonMethods.saveBoolPref('is_login', false);
                    CommonMethods.saveBoolPref('is_login', false);
                    Get.to(() => LoginPage());
                  });
                });
                // SharedPreferences mPref = await SharedPreferences.getInstance();
                // mPref.setBool('is_login', false);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => LoginPage())
                // );
              }),
            ],
          ),
        ),
      ),
    );
  }
  
}