import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:training_app/firebase/keys.dart';

class DatlyTrainingEdit extends StatefulWidget{
  final List dailyTrainDatum;
  final List otherTopData;
  DatlyTrainingEdit(this.dailyTrainDatum, this.otherTopData);
  DatlyTrainingEditState createState() => DatlyTrainingEditState();
}

class DatlyTrainingEditState extends State<DatlyTrainingEdit>{
  double _currentIndex = 0;
  List<TextEditingController> weightCtrl = [];
  List<TextEditingController> wattCtrl = [];
  List<TextEditingController> pulseCtrl = [];
  List<TextEditingController> avgPower = [];
  List<TextEditingController> codenceCtrl = [];
  List<TextEditingController> breakCtrl = [];
  List<TextEditingController> minTimeCtrl = [];
  List<TextEditingController> timeEstimateCtrl = [];
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController weightUpCtrl = TextEditingController();
  TextEditingController trainingEstimateCtrl = TextEditingController();
  Widget mReturnWigdet = Container();
  List<String> ratingList = [];

  List<String> wattList = [];
  List<String> pulseList = [];
  List<String> ahrList = [];
  List<String> codenceList = [];
  List<String> trainTimeList = [];
  List<String> breakList = [];

  String weightTop = '';
  String tttTop = '';
  String commentTop = '';
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
  Map? trainerMap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrainerToken();
    for(int i=0;i<widget.dailyTrainDatum.length;i++){
      TextEditingController wc = TextEditingController();
      TextEditingController wc1 = TextEditingController();
      TextEditingController wc2 = TextEditingController();
      TextEditingController wc3 = TextEditingController();
      TextEditingController wc4 = TextEditingController();
      TextEditingController wc5 = TextEditingController();
      TextEditingController wc6 = TextEditingController();
      TextEditingController wc7 = TextEditingController();
      weightCtrl.add(wc);
      wattCtrl.add(wc1);
      pulseCtrl.add(wc2);
      avgPower.add(wc3);
      codenceCtrl.add(wc4);
      timeEstimateCtrl.add(wc5);
      breakCtrl.add(wc6);
      minTimeCtrl.add(wc7);
      ratingList.add('0');

      // weightCtrl[i].text = widget.dailyTrainDatum[i]['a_power_watt'];
      String aPowWatt = widget.dailyTrainDatum[i].aPowerWatt;
      String aMaxPulse = widget.dailyTrainDatum[i].aMaxPlus;
      String aAvgPow = widget.dailyTrainDatum[i].aAveragePower;
      String aCodence = widget.dailyTrainDatum[i].aCandence;
      String aEstimate = widget.dailyTrainDatum[i].aTrainingsTimeMin;
      String aBreak = widget.dailyTrainDatum[i].aBreaks;
      // String aMinTime = widget.dailyTrainDatum[i]['a_trainings_time_min'];


      wattList.add((aPowWatt.isEmpty)?widget.dailyTrainDatum[i].powerWatt:aPowWatt);
      pulseList.add((aMaxPulse.isEmpty)?widget.dailyTrainDatum[i].pulse:aMaxPulse);
      ahrList.add((aAvgPow.isEmpty)?widget.dailyTrainDatum[i].aAveragePower:aAvgPow);
      trainTimeList.add((aEstimate.isEmpty)?widget.dailyTrainDatum[i].trainingstimeMin:aEstimate);
      codenceList.add((aCodence.isEmpty)?widget.dailyTrainDatum[i].cadence:aCodence);
      breakList.add((aBreak.isEmpty)?widget.dailyTrainDatum[i].breaks:aBreak);
      // minTimeCtrl[i].text = (aMinTime==null||aMinTime.isEmpty)?'0':aMinTime;

      ratingList[i] = widget.dailyTrainDatum[i].aRating;
    }
    weightTop = widget.otherTopData[0].aWeight;
    tttTop = widget.otherTopData[0].totalTrainingstime;
    commentTop = widget.otherTopData[0].aComment;
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

  Future<List<String>> getUserAndTrainerId()async{
    List<String> savedData = [];
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String userId = mPref.getString('user_id') as String;
    String trainerId = mPref.getString('trainer_id') as String;
    savedData.add(userId);
    savedData.add(trainerId);
    return savedData;
  }

  saveFullData()async{
    CommonMethods.showAlertDialog(context);
    List<Map> allIntervalMap = [];
    for(int i=0;i<widget.dailyTrainDatum.length;i++){
      Map innerMap = {
        'power_watt' : wattList[i],
        'max_plus' : pulseList[i],
        'average_power' : avgPower[i].text,
        'cadence' : codenceCtrl[i].text,
        'rating' : ratingList[i],
        'breaks' : breakCtrl[i].text,
        'time_min' : timeEstimateCtrl[i].text,
        'row_id' : widget.dailyTrainDatum[i].id
      };
      allIntervalMap.add(innerMap);
    }
    Map outerMap = {
      'Weight' : weightTop,
      'comment' : commentTop,
      'Trainings_time_min' : tttTop,
      'data' : allIntervalMap
    };
    String userId = await CommonMethods.getUserId();
    Response myResponse = await CommonMethods.commonPostApiData(ApiInterface.UPDATE_DAILY_TRAINING+userId, outerMap);
    Map resMap = json.decode(myResponse.data);
    Navigator.pop(context);
    sendAndRetrieveMessage(
        trainerMap!['auth_token'], "Data Saved",
        'Training data has been saved');
    Map notifSendMap = {
      "title": "File Data Saved",
      "message": "Training data has been saved"
    };
    List<String> detailData = await getUserAndTrainerId();
    Response myRes = await CommonMethods
        .commonPostApiData(
        ApiInterface.NOTIF_TO_TRAINER + detailData[0] +
            '/' + detailData[1], notifSendMap);
    CommonMethods.getDialoge('Your changes has been saved',intTitle: 2,voidCallback: (){
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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
    double mHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset : false,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10.0,),
                        Text(
                          'Edit Training',
                          style: GoogleFonts.roboto(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      saveFullData();
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        Text(
                          'Save',
                          style: GoogleFonts.roboto(
                              color: Colors.white
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: SizedBox(
                  height: mHeight*0.85,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weight',
                            style: GoogleFonts.roboto(
                                color: Colors.white
                            ),),
                          CommonWidgets.commonTextField(
                              mOnchangedStr: (str){
                                weightTop = str;
                              },
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.line_weight,
                              mTitle: widget.otherTopData[0].aWeight.isEmpty?'Weight':widget.otherTopData[0].aWeight,
                              keybordType: TextInputType.text,
                              mController: weightUpCtrl,
                              hintColor: Colors.grey,
                              mHeight: MediaQuery.of(context).size.height*0.07
                          ),
                          const SizedBox(height: 10.0,),
                          Text('Total Training Time',
                            style: GoogleFonts.roboto(
                                color: Colors.white
                            ),),
                          CommonWidgets.commonTextField(
                              mOnchangedStr: (str){
                                tttTop = str;
                              },
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.watch_later,
                              mTitle: (widget.otherTopData[0].totalTrainingstime).isEmpty?'Total Training Time':widget.otherTopData[0].totalTrainingstime,
                              keybordType: TextInputType.text,
                              mController: trainingEstimateCtrl,
                              hintColor: Colors.grey,
                              mHeight: MediaQuery.of(context).size.height*0.07
                          ),
                          const SizedBox(height: 10.0,),
                          Text('Comment',
                            style: GoogleFonts.roboto(
                                color: Colors.white
                            ),),
                          CommonWidgets.commonTextField(
                              mOnchangedStr: (str){
                                commentTop = str;
                              },
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.comment,
                              mTitle: widget.otherTopData[0].aComment.isEmpty?'Comment':widget.otherTopData[0].aComment,
                              keybordType: TextInputType.text,
                              mController: commentCtrl,
                              hintColor: Colors.grey,
                              mHeight: MediaQuery.of(context).size.height*0.07
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.dailyTrainDatum.length,
                          itemBuilder: (context, index){
                            var initValue = widget.dailyTrainDatum[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30.0,),
                                Center(child:
                                Text(widget.dailyTrainDatum[index].headline,
                                  style: GoogleFonts.roboto(
                                      color: CupertinoColors.white
                                  ),)),
                                const Divider(color: Colors.white,),
                                const SizedBox(height: 30.0,),
                                Text(
                                  'Power Watt',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mOnchangedStr: (str){
                                      String editValue = str;
                                      wattList.removeAt(index);
                                      wattList.insert(index, editValue);
                                    },
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: (initValue.aPowerWatt.isEmpty)?initValue.powerWatt:initValue.aPowerWatt,
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: wattCtrl[index],
                                    hintColor: Colors.grey,
                                    mHeight: MediaQuery.of(context).size.height*0.07
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  'Pulse',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mOnchangedStr: (str){
                                      String editValue = str;
                                      pulseList.removeAt(index);
                                      pulseList.insert(index, editValue);
                                    },
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: (initValue.aMaxPlus.isEmpty)?initValue.pulse:initValue.aMaxPlus,
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: pulseCtrl[index],
                                    hintColor: Colors.grey,
                                    mHeight: MediaQuery.of(context).size.height*0.07
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  'Avg Heart Rate',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mOnchangedStr: (str){
                                      String editValue = str;
                                      ahrList.removeAt(index);
                                      ahrList.insert(index, editValue);
                                    },
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: (initValue.aAveragePower.isEmpty)?initValue.aAveragePower:initValue.aAveragePower,
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: avgPower[index],
                                    hintColor: Colors.grey,
                                    mHeight: MediaQuery.of(context).size.height*0.07
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  'Codence',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mOnchangedStr: (str){
                                      String editValue = str;
                                      codenceList.removeAt(index);
                                      codenceList.insert(index, editValue);
                                    },
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: (initValue.aCandence.isEmpty)?initValue.cadence:initValue.aCandence,
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: codenceCtrl[index],
                                    hintColor: Colors.grey,
                                    mHeight: MediaQuery.of(context).size.height*0.07
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  'Trainings Time',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mOnchangedStr: (str){
                                      String editValue = str;
                                      trainTimeList.removeAt(index);
                                      trainTimeList.insert(index, editValue);
                                    },
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: (initValue.aTrainingsTimeMin.isEmpty)?initValue.trainingstimeMin:initValue.aTrainingsTimeMin,
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: timeEstimateCtrl[index],
                                    hintColor: Colors.grey,
                                    mHeight: MediaQuery.of(context).size.height*0.07
                                ),
                                const SizedBox(height: 10.0,),

                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: RatingBar.builder(
                                    unratedColor: Colors.white,
                                    initialRating: isNumeric(widget.dailyTrainDatum[index].aRating)?double.parse(widget.dailyTrainDatum[index].aRating==null?'0.0':widget.dailyTrainDatum[index].aRating):0.0,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      if(index == 0){
                                        mReturnWigdet = Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: _currentIndex == 1.0?Colors.green:Colors.white,
                                        );
                                      }
                                      else if(index == 1){
                                        mReturnWigdet = Icon(
                                          Icons.sentiment_satisfied,
                                          color:  _currentIndex == 2.0?Colors.lightGreen:Colors.white,
                                        );
                                      }
                                      else if(index == 2){
                                        mReturnWigdet = Icon(
                                          Icons.sentiment_neutral,
                                          color: _currentIndex == 3.0?Colors.amber:Colors.white,
                                        );
                                      }
                                      else if(index == 3){
                                        mReturnWigdet = Icon(
                                          Icons.sentiment_dissatisfied,
                                          color: _currentIndex == 4.0?Colors.redAccent:Colors.white,
                                        );
                                      }
                                      else if(index == 4){
                                        mReturnWigdet = Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: _currentIndex == 5.0?Colors.red:Colors.white,
                                        );
                                      }
                                      return mReturnWigdet;
                                    },
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                      ratingList[index] = rating.toString();
                                      _currentIndex = rating;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Break',
                                          style: GoogleFonts.roboto(
                                              color: CommonVar.RED_BUTTON_COLOR
                                          ),
                                        ),
                                        CommonWidgets.commonTextField(
                                            mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                            mTitle: (initValue.aBreaks.isEmpty)?initValue.breaks:initValue.aBreaks,
                                            shouldPreIcon: false,
                                            contentPadding: const EdgeInsets.all(10.0),
                                            mController: breakCtrl[index],
                                            hintColor: Colors.grey,
                                            isTextCenter: true,
                                            isNextCon:(index==breakCtrl.length-1)?false:true
                                        ),
                                      ],
                                    ),
                                ),
                                const SizedBox(height: 10.0,),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding(this.child);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}