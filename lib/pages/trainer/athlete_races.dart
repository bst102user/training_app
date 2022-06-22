import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/all_race_model.dart';
import 'package:training_app/models/trainer/athlete_races_model.dart';

class AthleteRaces extends StatefulWidget{
  final String athUserId;
  AthleteRaces(this.athUserId);
  AthleteRacesState createState() => AthleteRacesState();
}

class AthleteRacesState extends State<AthleteRaces>{
  bool shouldCal = true;
  Future<dynamic>? returnData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: Platform.isMacOS?const BoxDecoration(
          color: CommonVar.BLACK_BG_BG_COLOR,
        ):const BoxDecoration(
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
              CommonWidgets.mHeightSizeBox(height: 30.0),
              FutureBuilder(
                future: CommonMethods.getUserId(),
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return Center(child: LoadingBouncingLine());
                  }
                  else{
                    print(snapshot.data);
                    String userId = snapshot.data as String;
                    return FutureBuilder(
                      future: CommonMethods.getRequest(ApiInterface.SHOW_ATHLETE_RACES+widget.athUserId,context),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Center(child: LoadingBouncingLine());
                        }
                        else{
                          AthleteRacesModel allRaceModel = athleteRacesModelFromJson(snapshot.data.toString());
                          List<ARMDatum> allRaceDetum = allRaceModel.data;
                          if(allRaceDetum.length == 0){
                            return Container(
                              height: MediaQuery.of(context).size.height*0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No data found',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.0,
                                    color: Colors.white
                                  ),)
                                ],
                              ),
                            );
                          }
                          else{
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
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10.0),
                                                  child: Text(
                                                    allRaceDetum[i].goal,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white
                                                    ),
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
                        }
                      },
                    );
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
