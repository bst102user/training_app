import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/profile_model.dart';
import 'account_page.dart';
import 'monthly_overview.dart';

class Dashboard extends StatefulWidget{
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>{

  Future<List<String>> getDataList()async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String email = mPref.getString('user_email').toString();
    String fname = mPref.getString('user_fname').toString();
    String lname = mPref.getString('user_lname').toString();
    List<String> dataList = [];
    dataList.add(email);
    dataList.add(fname);
    dataList.add(lname);
    return dataList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget commonTile(String date, String time, IconData iconData){
    return Container(
        width: double.infinity,
        height: 80.0,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white,
                width: 2.0
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        child: Row(
          children: [
            Expanded(
                child: Icon(
                  iconData,
                  size: 60.0,
                  color: Colors.white,
            )
            ),
            const Center(
              child: VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: GoogleFonts.roboto(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.roboto(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            )
          ],
        )
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
              "assets/images/cycle_run.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
          child: ListView(
            children: [
              Text(
                'Dashboard'.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white
                ),
              ),
              CommonWidgets.mHeightSizeBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CommonVar.BLACK_TEXT_FIELD_COLOR),
                      ),
                      CommonWidgets.mWidthSizeBox(width: 20.0),
                      FutureBuilder(
                        future: getDataList(),
                        builder: (context, snapshot){
                          if(snapshot.data == null){
                            return const Text('Loading...');
                          }
                          else{
                            List<String> dataList = snapshot.data as List<String>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataList[1]+' '+dataList[2],
                                  style: GoogleFonts.roboto(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                  ),
                                ),
                                CommonWidgets.mHeightSizeBox(height: 10.0),
                                Text(
                                  dataList[0],
                                  style: GoogleFonts.roboto(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                       ),

                    ],
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(AccountPage());
                    },
                    child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      size: 30.0,
                    ),
                  )
                ],
              ),
              CommonWidgets.mHeightSizeBox(height: 30.0),
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                          ),
                          CommonWidgets.mHeightSizeBox(height: 10.0),
                          Text(
                            '20/01/2022',
                            style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: CommonVar.RED_BUTTON_COLOR
                            ),
                          ),
                        ],
                      ),
                      CommonWidgets.mWidthSizeBox(width: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                          ),
                          CommonWidgets.mHeightSizeBox(height: 10.0),
                          Text(
                            '8:24 am',
                            style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: CommonVar.RED_BUTTON_COLOR
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notification text....',
                        style: GoogleFonts.roboto(
                            fontSize: 16.0,
                            color: Colors.white
                        ),
                      ),
                      const Icon(
                          Icons.notifications_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  CommonWidgets.mHeightSizeBox(height: 30.0),
                  CommonWidgets.commonButton('Monthly Overview', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MonthlyOverview()));
                  },iconData: Icons.calendar_today),
                  CommonWidgets.mHeightSizeBox(height: 20.0),
                  const Center(
                    child: Icon(
                        Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                  ),
                  commonTile('12/03/2022', '120 min', Icons.timelapse_outlined),
                  const SizedBox(height: 15.0,),
                  commonTile('13/03/2022', '140 min', Icons.motorcycle),
                  const SizedBox(height: 15.0,),
                  commonTile('14/03/2022', '200 min', Icons.local_restaurant_rounded),
                  const Center(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}