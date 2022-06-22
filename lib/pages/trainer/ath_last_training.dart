import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/trainer/alt_model.dart';

class AthLastTraining extends StatefulWidget{
  final String athUserId;
  AthLastTraining(this.athUserId);
  AthLastTrainingState createState() => AthLastTrainingState();
}

class AthLastTrainingState extends State<AthLastTraining>{
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
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CommonWidgets.commonHeader(context, 'Last Training'),
            ),
            FutureBuilder(
              future: CommonMethods.commonGetApiData(ApiInterface.ATH_LAST_TRAINING+widget.athUserId),
              builder: (context, snapshot){
                if(snapshot.data == null){
                  return Center(child: LoadingBouncingLine(size: 50,));
                }
                else{
                  String result = snapshot.data.toString();
                  Map mMap = json.decode(result);
                  String isDataThere = mMap['status'];
                  var mData = mMap['data'];
                  if(isDataThere == 'error'||mData.runtimeType == bool){
                    return Container(
                      height: MediaQuery.of(context).size.height*0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No data found',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else{
                    String response = snapshot.data.toString();
                    AltModel dtm = altModelFromJson(response);
                    if(dtm.status == 'success'){
                      return Column(
                        children: [
                          Center(
                            child: Text(
                              // dtm.data[0].dates,
                              DateFormat('yyyy-MM-dd').format(dtm.data[0].dates),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          SizedBox(
                            height: CommonMethods.deviceHeight(context)*0.8,
                            child: ListView.builder(
                                itemCount: dtm.data.length,
                                itemBuilder: (context, index){
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: CommonVar.BLACK_TEXT_FIELD_COLOR2.withOpacity(0.8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.4,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width*0.4,
                                                    child: Text(
                                                      dtm.data[index].headline,
                                                      style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 17.0,
                                                      ),
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
                                                    dtm.data[index].aTrainingsTimeMin,
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
                                                    dtm.data[index].aPowerWatt,
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
                                                    dtm.data[index].aMaxPlus==null?'N/A':dtm.data[index].aMaxPlus,
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
                                                    dtm.data[index].aCandence==null?'N/A':dtm.data[index].aCandence,
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
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                                    dtm.data[index].aBreaks==null?'N/A':dtm.data[index].aBreaks,
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
}