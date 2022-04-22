import 'dart:convert';
import 'package:dio/dio.dart';
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
        });
      });
    }
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
                    CommonWidgets.commonHeader(context, 'daily training'),
                    CommonWidgets.mHeightSizeBox(height: 30.0),
                    CommonWidgets.containerLikeTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.calendar_today_outlined,
                        mTitle: workingDate
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
                          _selectDate(context);
                        }),
                        CommonWidgets.textBelowIcon(Icons.cancel_outlined, 'Miss', () {
                          CommonMethods.showAlertDialog(context);
                          Map mMap = {"null_date" : workingDate};
                          CommonMethods.commonPostApiData(ApiInterface.NOT_ATTEND+'/'+savedData[0], mMap).then((value)async{
                            Get.back();
                            String mResponse = value.data;
                            Map resMap = json.decode(mResponse);
                            String status = resMap['status'];
                            String message = resMap['msg'];
                            CommonMethods.showToast(context, message);//7/8
                            Map notifSendMap = {
                              "title" : "Miss Training",
                              "message" : "Today i am missing my training"
                            };
                            Response myRes = await CommonMethods.commonPostApiData(ApiInterface.NOTIF_TO_TRAINER+savedData[0]+'/'+savedData[1], notifSendMap);
                            print(ApiInterface.NOTIF_TO_TRAINER+savedData[0]+'/'+savedData[1]);
                          });
                        }),
                        CommonWidgets.textBelowIcon(Icons.sick_rounded, 'Sick', () {
                          CommonMethods.showAlertDialog(context);
                          Map mMap = {"ill_date" : workingDate};
                          CommonMethods.commonPostApiData(ApiInterface.UPDATE_ILLNESS+'/'+savedData[0], mMap).then((value)async{
                            Get.back();
                            String mResponse = value.data;
                            Map resMap = json.decode(mResponse);
                            String status = resMap['status'];
                            String message = resMap['msg'];
                            CommonMethods.showToast(context, message);
                            Map notifSendMap = {
                              "title" : "Sick message",
                              "message" : "Today i am not feeling well"
                            };;
                            Response myRes = await CommonMethods.commonPostApiData(ApiInterface.NOTIF_TO_TRAINER+savedData[0]+'/'+savedData[1], notifSendMap);
                          });
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
                            return Center(child: Column(
                              children: [
                                const SizedBox(height: 50.0,),
                                Text(
                                    ' No data found',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            )
                            );
                          }
                          else{
                            DailyTrainingModel dtm = dailyTrainingModelFromJson(snapshot.data.toString());
                            if(dtm.status == 'success'){
                              return Column(
                                children: [
                                  CommonWidgets.commonButton('Edit', () {
                                    Get.to(DatlyTrainingEdit(dtm.data))!.then((value){
                                      setState(() {

                                      });
                                    });
                                  }),
                                  SizedBox(
                                    height: CommonMethods.deviceHeight(context)*0.6,
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            dtm.data[index].headline==null?'No data':dtm.data[index].headline,
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                          // InkWell(
                                                          //   onTap: (){
                                                          //     Get.to(DatlyTrainingEdit(dtm.data[index]))!.then((value){
                                                          //       setState(() {
                                                          //
                                                          //       });
                                                          //     });
                                                          //   },
                                                          //   child: const Padding(
                                                          //     padding: EdgeInsets.all(8.0),
                                                          //     child: Icon(
                                                          //       Icons.edit,
                                                          //       color: Colors.white,
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      dtm.data[index].trainingstimeMin==null?'No data':dtm.data[index].trainingstimeMin,
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Text(
                                                      dtm.data[index].pulse==null?'No data':dtm.data[index].pulse+' pulse',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Text(
                                                      dtm.data[index].cadence==null?'No data':dtm.data[index].cadence,
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 15.0),
                                                    const Divider(
                                                      color: Colors.white,
                                                      thickness: 0.5,
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Break',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                          Text(
                                                            '5 Mins',
                                                            style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: 17.0,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    CommonWidgets.mHeightSizeBox(height: 10.0),
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