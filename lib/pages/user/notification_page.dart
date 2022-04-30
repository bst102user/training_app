import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/athlete_notif_model.dart';
import 'package:training_app/models/notification_model.dart';

class NotificationPage extends StatefulWidget{
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage>{

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


  Widget commonColumn(String key, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 5.0,),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.roboto(
            color: CommonVar.RED_BUTTON_COLOR,
          ),
        ),
      ],
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
              CommonWidgets.commonHeader(context, 'Notification'.toUpperCase()),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              FutureBuilder(
                future: CommonMethods.getUserId(),
                builder: (context,snapshot){
                  if(snapshot.data == null){
                    return const Text('Loading...');
                  }
                  else{
                    String userId = snapshot.data as String;
                    return FutureBuilder(
                      future: CommonMethods.getRequest(ApiInterface.ATHLETE_NOTIFICATIONS+userId, context),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Center(child: LoadingBouncingLine(size: 20,));
                        }
                        else{
                          Response myRes = snapshot.data as Response;
                          Map mMap = json.decode(myRes.data);
                          var data = mMap['data'];
                          if(data.runtimeType == bool){
                            return SizedBox(
                              height: MediaQuery.of(context).size.height*0.8,
                              child: Center(
                                child: Text('No Data found',
                                style: GoogleFonts.roboto(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                                ),),
                              ),
                            );
                          }
                          else{
                            AthleteNotifModel notifModel = athleteNotifModelFromJson(myRes.data);
                            List<AthlNotifDatum> listData = notifModel.data;
                            return SizedBox(
                              height: MediaQuery.of(context).size.height*0.9,
                              child: ListView.builder(
                                itemCount: listData.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listData[index].title,
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const SizedBox(height: 5.0,),
                                        Text(
                                          listData[index].msg,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Row(
                                          children: [
                                            commonColumn('Date', getDateTime(listData[index].createdAt, true)),
                                            const SizedBox(width: 100.0,),
                                            commonColumn('Time', getDateTime(listData[index].createdAt, false)),
                                          ],
                                        ),
                                        const Divider(color: Colors.white,)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    );
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }

}