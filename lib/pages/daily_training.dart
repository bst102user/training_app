import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/daily_training_model.dart';
import 'package:training_app/pages/daily_training_edit.dart';

class DailyTraining extends StatefulWidget{
  final DateTime dateTime;
  DailyTraining(this.dateTime);
  DailyTrainingState createState() => DailyTrainingState();
}

class DailyTrainingState extends State<DailyTraining>{
  Future<String> getUserId()async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String userId = mPref.getString('user_id') as String;
    return userId;
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
              CommonWidgets.commonHeader(context, 'daily training'),
              CommonWidgets.mHeightSizeBox(height: 30.0),
              CommonWidgets.containerLikeTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mIcon: Icons.calendar_today_outlined,
                mTitle: DateFormat('dd/MM/yyyy').format(widget.dateTime)
              ),
              CommonWidgets.mHeightSizeBox(height: 10.0),
              Center(
                child: Text(
                  '90 minutes',
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
                    // CommonMethods.commonPostApiData(ApiInterface., mMap)
                  }),
                  CommonWidgets.textBelowIcon(Icons.cancel_outlined, 'Miss', () {
                    CommonMethods.showAlertDialog(context);
                    Map mMap = {"null_date" : "12/29/2021"};
                    CommonMethods.commonPostApiData(ApiInterface.NOT_ATTEND, mMap).then((value){
                      Get.back();
                      String mResponse = value.data;
                      Map resMap = json.decode(mResponse);
                      String status = resMap['status'];
                      String message = resMap['msg'];
                      CommonMethods.showToast(context, message);
                    });
                  }),
                  CommonWidgets.textBelowIcon(Icons.sick_rounded, 'Sick', () {
                    CommonMethods.showAlertDialog(context);
                    Map mMap = {"ill_date" : "12/29/2021"};
                    CommonMethods.commonPostApiData(ApiInterface.UPDATE_ILLNESS, mMap).then((value){
                      Get.back();
                      String mResponse = value.data;
                      Map resMap = json.decode(mResponse);
                      String status = resMap['status'];
                      String message = resMap['msg'];
                      CommonMethods.showToast(context, message);
                    });
                  })
                ],
              ),
              CommonWidgets.mHeightSizeBox(height: 15.0),
              // FutureBuilder(),
              FutureBuilder(
                future: CommonMethods.commonPostApiData(ApiInterface.DAILY_TRAINING+'/6', {'first_date':'29/12/2021'}),
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return Text('Loading...');
                  }
                  else{
                    DailyTrainingModel dtm = dailyTrainingModelFromJson(snapshot.data.toString());
                    if(dtm.status == 'success'){
                      return SizedBox(
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
                                              InkWell(
                                                onTap: (){
                                                  Get.to(DatlyTrainingEdit(dtm.data[index]));
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
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
                      );
                    }
                    else{
                      return Text('No Data ');
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}