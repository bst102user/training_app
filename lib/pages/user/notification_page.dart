import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/notification_model.dart';

class NotificationPage extends StatefulWidget{
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage>{
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
              // FutureBuilder(
              //   future: CommonMethods.getRequest(ApiInterface.NOTIFICATIONS, context),
              //   builder: (context, snapshot){
              //     if(snapshot.data == null){
              //       return Center(child: LoadingBouncingLine());
              //     }
              //     else{
              //       Response myRes = snapshot.data as Response;
              //       String dataStr = myRes.data as String;
              //       NotificationModel nModel = notificationModelFromJson(dataStr);
              //       List
              //       print(dataStr);
              //       return Text('fff');
              //     }
              //   },
              // ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Training well done',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Text(
                      'Your training has been completely done enjoy your other things',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      children: [
                        commonColumn('Date', '20-01-2022'),
                        const SizedBox(width: 100.0,),
                        commonColumn('Time', '08:31 AM'),
                      ],
                    ),
                    const Divider(color: Colors.white,)
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training well done',
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Text(
                      'Your training has been completely done enjoy your other things',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      children: [
                        commonColumn('Date', '20-01-2022'),
                        const SizedBox(width: 100.0,),
                        commonColumn('Time', '08:31 AM'),
                      ],
                    ),
                    const Divider(color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}