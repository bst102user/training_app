import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/pages/document_page.dart';
import 'package:training_app/pages/login_page.dart';
import 'package:training_app/pages/profile_page.dart';
import 'package:training_app/pages/upgrade_page.dart';

class AccountPage extends StatefulWidget{
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage>{
  logoutDialoge(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Would you like to logout from the Application?",
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 50,),
                      FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            CommonMethods.saveBoolPref('is_login', false);
                            Get.to(() => LoginPage());
                          }),

                    ])
              ],
            ),
          );
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
              "assets/images/cycle_blur.png",
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
              commonView(Icons.person, 'Profile',mCallback: (){
                Get.to(ProfilePage());
              }),
              commonView(Icons.notifications_rounded, 'Notification'),
              commonView(Icons.calendar_today_outlined, 'Race Calender'),
              commonView(Icons.document_scanner, 'Documents',mCallback: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocumentPage())
                );
              }),
              commonView(Icons.person, 'Offers'),
              commonView(Icons.person, 'Upgrade',mCallback: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpgradePage())
                );
              }),
              commonView(Icons.person, 'Logout',mCallback: (){
                logoutDialoge();
              }),
            ],
          ),
        ),
      ),
    );
  }

}