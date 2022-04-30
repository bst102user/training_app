import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/methods.dart';
import 'package:training_app/pages/user/login_page.dart';
import 'package:training_app/pages/user/notification_page.dart';
import 'document_page.dart';
import 'profile_page.dart';
import 'racing_calender.dart';
import 'upgrade_page.dart';

class AccountPage extends StatefulWidget{
  final bool isBackIcon;
  AccountPage(this.isBackIcon);
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage>{


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
              CommonWidgets.commonHeader(context, 'account',isShowBack: widget.isBackIcon),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView(Icons.person, 'Profile',mCallback: (){
                Get.to(ProfilePage());
              }),
              commonView(Icons.notifications_rounded, 'Notification',mCallback: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage()));
              }),
              commonView(Icons.calendar_today_outlined, 'Race Calender',mCallback: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>RacingCalender()));
                Get.to(RacingCalender());
              }),
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
              commonView(Icons.person, 'Logout',mCallback: ()async{
                CommonMethods.twoButtonDialoge(context, 'Logout', 'Would you like to logout from the Application?',(){
                  logOut(context).then((value)async{
                    CommonMethods.saveStrPref('profile_fullpath', '');
                    CommonMethods.saveStrPref('trainer_id', '0');
                    CommonMethods.saveStrPref('user_id', '');
                    CommonMethods.saveStrPref('user_email', '');
                    CommonMethods.saveStrPref('user_fname', '');
                    CommonMethods.saveStrPref('user_lname', '');
                    CommonMethods.saveStrPref('trainer_id', '');
                    CommonMethods.saveStrPref('user_type', '');
                    CommonMethods.saveBoolPref('is_login', false);
                    Get.to(() => LoginPage());
                  });
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

}