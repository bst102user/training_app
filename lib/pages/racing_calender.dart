import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/all_race_model.dart';
import 'package:training_app/pages/add_race.dart';

class RacingCalender extends StatefulWidget{
  RacingCalenderState createState() => RacingCalenderState();
}

class RacingCalenderState extends State<RacingCalender>{
  bool shouldCal = true;
  Future<dynamic>? returnData;
  // Future<dynamic>? allRaceData(){
  //   CommonMethods.commonGetApiData(ApiInterface.ALL_RACEES).then((response){
  //     Map mMap = json.decode(response.toString());
  //     if(mMap['status'] == 'success'){
  //       if(shouldCal) {
  //         setState(() {
  //           AllRaceModel allRaceModel = allRaceModelFromJson(response.toString());
  //           returnData = allRaceModel as Future<dynamic>?;
  //           shouldCal = false;
  //         });
  //       }
  //     }
  //     else{
  //       setState(() {
  //         returnData = null;
  //       });
  //     }
  //   });
  //   return returnData;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/cycle_climb.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
          child: ListView(
            children: [
              CommonWidgets.commonHeader(context, 'Racing Calender'),
              CommonWidgets.mHeightSizeBox(height: 30.0),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddRace()));
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CommonVar.BLACK_TEXT_FIELD_COLOR2.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)
                    ),
                  ),
                  child: Row(
                    children: [
                      CommonWidgets.mWidthSizeBox(width: 10.0),
                      const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      CommonWidgets.mWidthSizeBox(width: 20.0),
                      Text(
                        'Add'.toUpperCase(),
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CommonWidgets.mHeightSizeBox(height: 30.0),
              FutureBuilder(
                future: CommonMethods.getRequest(ApiInterface.ALL_RACEES,context),
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return Text('Loading...');
                  }
                  else{
                    AllRaceModel allRaceModel = allRaceModelFromJson(snapshot.data.toString());
                    List<AllRaceDatum> allRaceDetum = allRaceModel.data;
                    return Container(
                      height: CommonMethods.deviceHeight(context)*0.7,
                      child: ListView.builder(
                        itemCount: allRaceDetum.length,
                        itemBuilder: (context, i){
                          return Column(
                            children: [
                              Container(
                                height: 100.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: CommonVar.BLACK_TEXT_FIELD_COLOR2.withOpacity(0.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CommonWidgets.mWidthSizeBox(width: 10.0),
                                            const Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                            ),
                                            CommonWidgets.mWidthSizeBox(width: 20.0),
                                            Text(
                                              allRaceDetum[i].name,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CommonWidgets.mWidthSizeBox(width: 10.0),
                                            const Icon(
                                              Icons.speed_outlined,
                                              color: Colors.white,
                                            ),
                                            CommonWidgets.mWidthSizeBox(width: 20.0),
                                            Text(
                                              DateFormat('dd-MM-yyyy').format(allRaceDetum[i].updatedAt),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0,)
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

}