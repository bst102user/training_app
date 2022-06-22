import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/athlete_notif_model.dart';
import 'package:training_app/models/profile_model.dart';
import 'package:training_app/models/training_date_model.dart';
import 'package:training_app/pages/user/daily_training.dart';
import 'package:training_app/pages/user/notification_page.dart';
import 'account_page.dart';
import 'monthly_overview.dart';

class Dashboard extends StatefulWidget{
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>{
  Color scrollHintColor = Colors.black;
  String totalMonthTime = '0';
  int totalTimeInt = 0;
  // List<DateTime> toHighlight = [];
  Map<DateTime,String> toHighlight = {};
  List<String> isUpdated = [];
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

  String getDateTime(DateTime dateTime, bool isDateReturn){
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    if(isDateReturn){
      return formattedDate;
    }
    else{
      return formattedTime;
    }
  }

  Future<dynamic> getLastNotification() async {
    String userId = await CommonMethods.getUserId();
    Response myRes = await CommonMethods.getRequest(ApiInterface.NOTIFICATIONS+userId, context);
    Map mMap = json.decode(myRes.data);
    dynamic isData = mMap['data'];
    if(isData is bool) {
      return 'no_data';
    }
    else{
      AthleteNotifModel notifModel = athleteNotifModelFromJson(myRes.data);
      List<AthlNotifDatum> listData = notifModel.data;
      return listData[listData.length - 1];
    }
  }




  getProfileData()async{
    // CommonMethods.showAlertDialog(context);
    Dio dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    // String userId = CommonMethods.getStrPref('user_id').toString();
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String str = mPref.getString('user_id').toString();
    try {
      var response = await Dio().get(ApiInterface.GET_PROFILE+str);
      print(response);
      // Get.back();
      setState(() {
        ProfileModel profileModel = profileModelFromJson(response.toString());
        List<ProfileDatum> listData = profileModel.data;
        String profilePictureName = listData[0].profileImage;
        mPref.setString("profile_fullpath",profilePictureName);
        mPref.setString('user_email',listData[0].email);
        mPref.setString('user_fname',listData[0].fname);
        mPref.setString('user_lname',listData[0].lname);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
    // testDistnict();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // Navigator.pushNamed(
        //   context,
        //   '/message',
        //   arguments: MessageArguments(message, true),
        // );
      }
    });
  }

  getToken()async{
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  Widget commonTile(String date, String time, IconData iconData){
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.11,
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
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        time==''?'0 min':time+' min',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03,),
      ],
    );
  }

  Future<String> getImageUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String imgUrl = preferences.getString("profile_fullpath").toString();
    print(imgUrl);
    return imgUrl;
  }

  bool isDate(String input, String format) {
    try {
      final DateTime d = DateFormat(format).parseStrict(input);
      //print(d);
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
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
                'Dashboard',
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
                      FutureBuilder(
                        future: getImageUrl(),
                        builder: (context, snapshot){
                          if(snapshot.data == null){
                            return const CircleAvatar(
                              radius: 30.0,
                              foregroundImage:
                              NetworkImage(
                                'https://via.placeholder.com/150',
                              ),
                              backgroundColor: Colors.transparent,
                            );
                          }
                          else{
                            String imagePath = snapshot.data as String;
                            if(imagePath.length<5){
                              return const CircleAvatar(
                                radius: 30.0,
                                foregroundImage:
                                NetworkImage(
                                  'https://via.placeholder.com/150',
                                ),
                                backgroundColor: Colors.transparent,
                              );
                            }
                            else if(imagePath.substring(imagePath.length - 5) == '.jpeg'
                                ||imagePath.substring(imagePath.length - 4) == '.png'
                                ||imagePath.substring(imagePath.length - 4)=='.jpg') {
                              return CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                NetworkImage(ApiInterface.PROFILE_IMAGE_PATH+(snapshot.data as String)),
                                backgroundColor: Colors.transparent,
                              );
                            }
                            else{
                              return const CircleAvatar(
                                radius: 30.0,
                                foregroundImage:
                                NetworkImage(
                                  'https://via.placeholder.com/150',
                                ),
                                backgroundColor: Colors.transparent,
                              );
                            }
                          }
                        },
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
                                      fontSize: 15.0,
                                      color: Colors.white
                                  ),
                                ),
                                CommonWidgets.mHeightSizeBox(height: 10.0),
                                Text(
                                  dataList[0],
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.0,
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
                      Get.to(AccountPage(true))!.then((value){
                        setState(() {
                          getProfileData();
                        });
                      });
                    },
                    child: const Icon(
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
                  FutureBuilder(
                    future: getLastNotification(),
                    builder: (context, snapshot){
                      if(snapshot.data == null){
                        return CommonWidgets.loadinBounce();
                      }
                      else{
                        var myResponse = snapshot.data;
                        if(myResponse == 'no_data') {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'No Recent Notification',
                              style: GoogleFonts.roboto(
                                  color: CupertinoColors.white,
                              ),
                            ),
                          );
                        }
                        else{
                          AthlNotifDatum data = snapshot.data as AthlNotifDatum;
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage()));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Date',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          getDateTime(data.createdAt, true),
                                          style: GoogleFonts.roboto(
                                              color: CommonVar.RED_BUTTON_COLOR
                                          ),
                                        ),
                                      ],
                                    ),
                                    CommonWidgets.mWidthSizeBox(width: 30.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'Time',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          getDateTime(data.createdAt, false),
                                          style: GoogleFonts.roboto(
                                              color: CommonVar.RED_BUTTON_COLOR
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:MediaQuery.of(context).size.width*0.8,
                                      child: Text(
                                        data.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.notifications_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),

                  CommonWidgets.mHeightSizeBox(height: 30.0),
                  CommonWidgets.commonButton('Monthly Overview', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MonthlyOverview(toHighlight)));
                  },
                      iconData: const Icon(Icons.calendar_today,
                      color: Colors.white,),
                      mHeight: 65.0,
                      iconSize: 30.0),
                  CommonWidgets.mHeightSizeBox(height: 20.0),
                  FutureBuilder(
                    future: CommonMethods.getUserId(),
                    builder: (context, snapshot){
                      if(snapshot.data == null){
                        return const Text('Loading..');
                      }
                      else{
                        String userId = snapshot.data as String;
                        return FutureBuilder(
                          future: CommonMethods.commonGetApiData(ApiInterface.TRAINING_DATES+userId),
                          builder: (context, snapshot){
                            if(snapshot.data == null){
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      value: 0.8,
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Text('Loading...',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white
                                      ),)
                                  ],
                                ),
                              );
                            }
                            else{
                              Response myRes = snapshot.data as Response;
                              Map myMap = json.decode(myRes.data);
                              if(myMap['data'].runtimeType == bool){
                                return SizedBox(
                                    child: Text(
                                        'No training data found',
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 17.0
                                      ),
                                    )
                                );
                              }
                              else{
                                TrainingDateModel dates = trainingDateModelFromJson(myRes.data);
                                List<TrainingDateDatum> listData = dates.data;

                                for(int i=0;i<listData.length;i++){
                                  totalTimeInt = totalTimeInt+int.parse(listData[i].totalRainingstime);
                                  // toHighlight.add(listData[i].dates);
                                  toHighlight[listData[i].dates] = listData[i].isUpdate;
                                }
                                totalMonthTime = totalTimeInt.toString();
                                return Column(
                                  children: [
                                    const Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.4,
                                      child: ListView.builder(
                                        itemCount: listData.length,
                                        itemBuilder: (context, index){
                                          return InkWell(
                                              onTap: (){
                                                Get.to(DailyTraining(listData[index].dates));
                                              },
                                              child: commonTile(listData[index].dates==null?'':DateFormat('dd-MM-yyyy').format(listData[index].dates), listData[index].totalRainingstime==null?'':listData[index].totalRainingstime, Icons.timelapse_outlined)
                                          );
                                        },
                                      ),
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                    },
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