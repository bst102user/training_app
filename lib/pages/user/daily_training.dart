import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_animated/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/keys.dart';
import 'package:training_app/models/daily_training_model.dart';
import 'daily_training_edit.dart';
import 'package:http/http.dart' as http;

class DailyTraining extends StatefulWidget{
  final DateTime dateTime;
  DailyTraining(this.dateTime);
  DailyTrainingState createState() => DailyTrainingState();
}

class DailyTrainingState extends State<DailyTraining>{
  String moveDateStr = 'Choose date for move';
  bool mIsDataThere = false;

  CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
  Map? trainerMap;

  Future<List<String>> getUserAndTrainerId()async{
    List<String> savedData = [];
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String userId = mPref.getString('user_id') as String;
    String trainerId = mPref.getString('trainer_id') as String;
    savedData.add(userId);
    savedData.add(trainerId);
    return savedData;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    String userId = await CommonMethods.getUserId();
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String myTrainerId = mPref.getString('trainer_id') as String;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        moveDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
        Map mMap = {
          "real_date" : DateFormat('yyyy-MM-dd').format(widget.dateTime),
          "change_date" : moveDateStr
        };
        CommonMethods.commonPostApiData(ApiInterface.MOVE_RACE+'/'+userId, mMap).then((value)async{
          Response mRes = value as Response;
          String strRes = mRes.data;
          Map resMap = json.decode(strRes);
          String message = resMap['msg'];
          CommonMethods.showToast(context, message);
          Map notifSendMap = {
            "title" : "Move date",
            'message' : 'I move my training on '+moveDateStr
          };
          Response myRes = await CommonMethods.commonPostApiData(ApiInterface.NOTIF_TO_TRAINER+userId+'/'+myTrainerId, notifSendMap);
          sendAndRetrieveMessage(trainerMap!['auth_token'], "Move date", 'I move my training on '+moveDateStr);
        });
      });
    }
  }

  @override
  initState(){
    super.initState();
    getTrainerToken();
  }

  Future<dynamic> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);

    return allData;
  }

  Future<dynamic> getCurrentUser()async{
    List<String> sharePrefValue = [];
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String emailStr = mPref.getString('user_email') as String;
    String userId = mPref.getString('user_id') as String;
    String trainerId = mPref.getString('trainer_id') as String;
    sharePrefValue.add(emailStr);
    sharePrefValue.add(userId);
    sharePrefValue.add(trainerId);
    return sharePrefValue;
  }

  getTrainerToken()async {
    List usersList = await getData();
    List<String> prefVal = await getCurrentUser();
    for(int index=0;index<usersList.length;index++){
      if(usersList[index]['user_type'] == 'trainer' && usersList[index]['trainer_id'] == prefVal[2]){
        trainerMap = usersList[index];
        print(trainerMap);
      }
    }
  }


  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token,String title,String body) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    Uri mUri = Uri.parse(url);
    var res = await http.post(
      mUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$MY_SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'navigate' : 'notification'
          },
          'to': token,
        },
      ),
    );

    print(res);
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(message);
      }
    });

    return completer.future;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String workingDate = DateFormat('yyyy-MM-dd').format(widget.dateTime);
    return Scaffold(
      body: FutureBuilder(
        future: getUserAndTrainerId(),
        builder: (context, snapshot){
          if(snapshot.data == null){
            return Container();
          }
          else{
            List<String> savedData = snapshot.data as List<String>;
            return Container(
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
                    CommonWidgets.commonHeader(context, 'Daily Training'),
                    CommonWidgets.mHeightSizeBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          workingDate,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        FutureBuilder(
                          future: CommonMethods.commonPostApiData(ApiInterface.DAILY_TRAINING+savedData[0], {'first_date' : workingDate}),
                          builder: (context, snapshot){
                            if(snapshot.data == null){
                              return Center(child: LoadingBouncingLine(size: 50,));
                            }
                            else{
                              String result = snapshot.data.toString();
                              Map mMap = json.decode(result);
                              String isDataThere = mMap['status'];
                              if(isDataThere == 'error'){
                                return const Text(
                                  '0',
                                );
                              }
                              else{
                                mIsDataThere = true;
                                String response = snapshot.data.toString();
                                DailyTrainingModel dtm = dailyTrainingModelFromJson(response);
                                if(dtm.status == 'success'){
                                  return Column(
                                    children: [
                                      Text(
                                        'Total Training Time',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        dtm.msg[0].totalTrainingstime,
                                        style: GoogleFonts.roboto(
                                            color: Colors.white
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                else{
                                  return const Text('');
                                }
                              }
                            }
                          },
                        )
                      ],
                    ),
                    CommonWidgets.mHeightSizeBox(height: 10.0),
                    Center(
                      child: Text(
                        ' ',
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                    ),
                    CommonWidgets.mHeightSizeBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidgets.textBelowIcon(Icons.outbox, 'Move', () {
                          if(mIsDataThere) {
                            _selectDate(context);
                          }
                          else{
                            CommonMethods.getDialoge('You can not move data',intTitle: 1,voidCallback: (){
                              Navigator.pop(context);
                            });
                          }
                        }),
                        CommonWidgets.textBelowIcon(Icons.cancel_outlined, 'Miss', () {
                          if(mIsDataThere) {
                            CommonMethods.showAlertDialog(context);
                            Map mMap = {"null_date": workingDate};
                            CommonMethods.commonPostApiData(
                                ApiInterface.NOT_ATTEND + '/' + savedData[0],
                                mMap).then((value) async {
                              Get.back();
                              String mResponse = value.data;
                              Map resMap = json.decode(mResponse);
                              String status = resMap['status'];
                              String message = resMap['msg'];
                              CommonMethods.showToast(context, message);
                              Map notifSendMap = {
                                "title": "Miss Training",
                                "message": "Today i am missing my training"
                              };
                              Response myRes = await CommonMethods
                                  .commonPostApiData(
                                  ApiInterface.NOTIF_TO_TRAINER + savedData[0] +
                                      '/' + savedData[1], notifSendMap);
                              print(
                                  ApiInterface.NOTIF_TO_TRAINER + savedData[0] +
                                      '/' + savedData[1]);
                              sendAndRetrieveMessage(
                                  trainerMap!['auth_token'], "Miss Training",
                                  'Today i am missing my training');
                            });
                          }
                          else{
                            CommonMethods.getDialoge('You do not have any training data',intTitle: 1,voidCallback: (){
                              Navigator.pop(context);
                            });
                          }
                        }),
                        CommonWidgets.textBelowIcon(Icons.sick_rounded, 'Sick', () {
                          if(mIsDataThere) {
                            CommonMethods.showAlertDialog(context);
                            Map mMap = {"ill_date": workingDate};
                            CommonMethods.commonPostApiData(
                                ApiInterface.UPDATE_ILLNESS + '/' +
                                    savedData[0], mMap).then((value) async {
                              Get.back();
                              String mResponse = value.data;
                              Map resMap = json.decode(mResponse);
                              String status = resMap['status'];
                              String message = resMap['msg'];
                              CommonMethods.showToast(context, message);
                              Map notifSendMap = {
                                "title": "Sick message",
                                "message": "Today i am not feeling well"
                              };
                              ;
                              Response myRes = await CommonMethods
                                  .commonPostApiData(
                                  ApiInterface.NOTIF_TO_TRAINER + savedData[0] +
                                      '/' + savedData[1], notifSendMap);
                              sendAndRetrieveMessage(
                                  trainerMap!['auth_token'], "Sick message",
                                  'Today i am not feeling well');
                            });
                          }
                          else{
                            CommonMethods.getDialoge('You do not have any training data',intTitle: 1,voidCallback: (){
                              Navigator.pop(context);
                            });
                          }
                        })
                      ],
                    ),
                    CommonWidgets.mHeightSizeBox(height: 15.0),
                    // FutureBuilder(),
                    FutureBuilder(
                      future: CommonMethods.commonPostApiData(ApiInterface.DAILY_TRAINING+savedData[0], {'first_date' : workingDate}),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Center(child: LoadingBouncingLine(size: 50,));
                        }
                        else{
                          String result = snapshot.data.toString();
                          Map mMap = json.decode(result);
                          String isDataThere = mMap['status'];
                          if(isDataThere == 'error'){
                            mIsDataThere = false;
                            return Center(child: Column(
                              children: [
                                const SizedBox(height: 50.0,),
                                Text(
                                    ' No data found',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            )
                            );
                          }
                          else{
                            mIsDataThere = true;
                            String response = snapshot.data.toString();
                            DailyTrainingModel dtm = dailyTrainingModelFromJson(response);
                            if(dtm.status == 'success'){
                              return Column(
                                children: [
                                  CommonWidgets.commonButton('Edit', () {
                                    Get.to(DatlyTrainingEdit(dtm.data,dtm.msg))!.then((value){
                                      setState(() {

                                      });
                                    });
                                  },
                                  mHeight: MediaQuery.of(context).size.height*0.08
                                  ),
                                  const SizedBox(height: 15.0,),
                                  SizedBox(
                                    height: CommonMethods.deviceHeight(context)*0.55,
                                    child: ListView.builder(
                                        itemCount: dtm.data.length,
                                        itemBuilder: (context, index){
                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: CommonVar.BLACK_TEXT_FIELD_COLOR2.withOpacity(0.8),
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(10)
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                          child: Text(
                                                            dtm.data[index].headline,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 15.0,),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                          child: Text(
                                                            dtm.data[index].trainingstimeMin,
                                                            style: GoogleFonts.roboto(
                                                              color: Colors.white,
                                                              fontSize: 17.0,
                                                            ),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                          child: Text(
                                                            dtm.data[index].powerWatt,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                            ),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                          child: Text(
                                                            dtm.data[index].pulse==null?'N/A':dtm.data[index].pulse,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,

                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.4,
                                                          child: Text(
                                                            dtm.data[index].cadence==null?'N/A':dtm.data[index].cadence,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                            ),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 15.0),
                                                    const Divider(
                                                      color: Colors.white,
                                                      thickness: 0.5,
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Break',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,

                                                            ),
                                                          ),
                                                          Text(
                                                            dtm.data[index].breaks==null?'N/A':dtm.data[index].breaks,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    const Divider(
                                                      color: Colors.white,
                                                      thickness: 0.5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CommonWidgets.mHeightSizeBox(height: 15.0),
                                            ],
                                          );
                                        }
                                    ),
                                  ),
                                ],
                              );
                            }
                            else{
                              return const Text(' No Data ');
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}