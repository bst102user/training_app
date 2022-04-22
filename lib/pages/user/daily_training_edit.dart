import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/daily_training_model.dart';

class DatlyTrainingEdit extends StatefulWidget{
  final List<DailyTrainDatum> dailyTrainDatum;
  DatlyTrainingEdit(this.dailyTrainDatum);
  DatlyTrainingEditState createState() => DatlyTrainingEditState();
}

class DatlyTrainingEditState extends State<DatlyTrainingEdit>{
  List<TextEditingController> weightCtrl = [];
  List<TextEditingController> wattCtrl = [];
  List<TextEditingController> pulseCtrl = [];
  List<TextEditingController> avgPower = [];
  List<TextEditingController> codenceCtrl = [];
  List<TextEditingController> timeEstimateCtrl = [];
  TextEditingController commentCtrl = TextEditingController();
  Widget mReturnWigdet = Container();
  String rateStr = '0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<widget.dailyTrainDatum.length;i++){
      TextEditingController wc = TextEditingController();
      TextEditingController wc1 = TextEditingController();
      TextEditingController wc2 = TextEditingController();
      TextEditingController wc3 = TextEditingController();
      TextEditingController wc4 = TextEditingController();
      TextEditingController wc5 = TextEditingController();
      weightCtrl.add(wc);
      wattCtrl.add(wc1);
      pulseCtrl.add(wc2);
      avgPower.add(wc3);
      codenceCtrl.add(wc4);
      timeEstimateCtrl.add(wc5);

      weightCtrl[i].text = widget.dailyTrainDatum[i].aWeight;
      wattCtrl[i].text = widget.dailyTrainDatum[i].aPowerWatt;
      pulseCtrl[i].text = widget.dailyTrainDatum[i].aMaxPlus;
      avgPower[i].text = widget.dailyTrainDatum[i].aAveragePower;
      codenceCtrl[i].text = widget.dailyTrainDatum[i].aCandence;
      timeEstimateCtrl[i].text = widget.dailyTrainDatum[i].aTrainingstime;
    }
  }

  saveFullData()async{
    CommonMethods.showAlertDialog(context);
    List<Map> allIntervalMap = [];
    for(int i=0;i<widget.dailyTrainDatum.length;i++){
      Map innerMap = {
        'power_watt' : wattCtrl[i].text,
        'max_plus' : pulseCtrl[i].text,
        'average_power' : avgPower[i].text,
        'cadence' : codenceCtrl[i].text,
        'Trainings_time_min' : timeEstimateCtrl[i].text,
        'weight' : weightCtrl[i].text,
        'row_id' : widget.dailyTrainDatum[i].id
      };
      allIntervalMap.add(innerMap);
    }
    Map outerMap = {
      'rating' : '4',
      'comment' : commentCtrl.text,
      'data' : allIntervalMap
    };
    String userId = await CommonMethods.getUserId();
    Response myResponse = await CommonMethods.commonPostApiData(ApiInterface.UPDATE_DAILY_TRAINING+userId, outerMap);
    Map resMap = json.decode(myResponse.data);
    Navigator.pop(context);
    CommonMethods.getDialoge(resMap['msg'],intTitle: 2,voidCallback: (){
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }


  @override
  Widget build(BuildContext context) {
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
          child: Column(children: [
            const SizedBox(height: 20.0,),
            CommonWidgets.commonHeader(context, 'Edit Training'),
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  unratedColor: Colors.white,
                  initialRating: rateStr==null?0.0:double.parse(rateStr),
                  itemCount: 5,
                  itemBuilder: (context, index) {

                    if(index == 0){
                      mReturnWigdet = const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    }
                    else if(index == 1){
                      mReturnWigdet = const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    }
                    else if(index == 2){
                      mReturnWigdet = const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    }
                    else if(index == 3){
                      mReturnWigdet = const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    }
                    else if(index == 4){
                      mReturnWigdet = const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    }
                    return mReturnWigdet;
                  },
                  onRatingUpdate: (rating) {
                    print(rating);
                    rateStr = (rating).toString();
                  },
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
                        'Save'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mIcon: Icons.comment,
                mTitle: 'Comment',
                keybordType: TextInputType.text,
                mController: commentCtrl
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.7,
              child: ListView.builder(
                itemCount: widget.dailyTrainDatum.length,
                itemBuilder: (context, index){
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
                      Text(
                        'Weight',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Weight',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: weightCtrl[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 30.0,),
                      Text(
                        'Power Watt',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Power Watt',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: wattCtrl[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        'Pulse',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Pulse',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: pulseCtrl[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        'Avg Power',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Avg Power',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: avgPower[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        'Codence',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Codence',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: codenceCtrl[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        'Time estimate min',
                        style: GoogleFonts.roboto(
                            color: CommonVar.RED_BUTTON_COLOR
                        ),
                      ),
                      CommonWidgets.commonTextField(
                          mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                          mTitle: 'Time estimate min',
                          shouldPreIcon: false,
                          contentPadding: const EdgeInsets.all(10.0),
                          mController: timeEstimateCtrl[index],
                          hintColor: Colors.grey
                      ),
                      const SizedBox(height: 10.0,),
                      // Text(
                      //   'Comment',
                      //   style: GoogleFonts.roboto(
                      //       color: CommonVar.RED_BUTTON_COLOR
                      //   ),
                      // ),
                      // CommonWidgets.commonTextField(
                      //     mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                      //     mTitle: 'Comment',
                      //     shouldPreIcon: false,
                      //     contentPadding: const EdgeInsets.all(10.0),
                      //     mController: commentCtrl,
                      //     hintColor: Colors.grey
                      // ),
                      // const SizedBox(height: 10.0,),
                      // Center(
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Rate',
                      //         style: GoogleFonts.roboto(
                      //             fontSize: 20.0,
                      //             color: CommonVar.RED_BUTTON_COLOR,
                      //             fontWeight: FontWeight.w600
                      //         ),
                      //       ),
                      //       RatingBar.builder(
                      //         unratedColor: Colors.white,
                      //         initialRating: rateStr==null?0.0:double.parse(rateStr),
                      //         itemCount: 5,
                      //         itemBuilder: (context, index) {
                      //
                      //           if(index == 0){
                      //             mReturnWigdet = const Icon(
                      //               Icons.sentiment_very_dissatisfied,
                      //               color: Colors.red,
                      //             );
                      //           }
                      //           else if(index == 1){
                      //             mReturnWigdet = const Icon(
                      //               Icons.sentiment_dissatisfied,
                      //               color: Colors.redAccent,
                      //             );
                      //           }
                      //           else if(index == 2){
                      //             mReturnWigdet = const Icon(
                      //               Icons.sentiment_neutral,
                      //               color: Colors.amber,
                      //             );
                      //           }
                      //           else if(index == 3){
                      //             mReturnWigdet = const Icon(
                      //               Icons.sentiment_satisfied,
                      //               color: Colors.lightGreen,
                      //             );
                      //           }
                      //           else if(index == 4){
                      //             mReturnWigdet = const Icon(
                      //               Icons.sentiment_very_satisfied,
                      //               color: Colors.green,
                      //             );
                      //           }
                      //           return mReturnWigdet;
                      //         },
                      //         onRatingUpdate: (rating) {
                      //           print(rating);
                      //           rateStr = (rating).toString();
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20.0,),
                      // CommonWidgets.commonButton('Save', ()async {
                      //   String userId = await CommonMethods.getUserId();
                      //   Map updateMap = {
                      //     "power_watt" : wattCtrl.text,
                      //     "max_plus" : pulseCtrl.text,
                      //     "average_power" : avgPulse.text,
                      //     "cadence" : codenceCtrl.text,
                      //     // "rating" : rateStr,
                      //     "Trainings_time_min" : timeEstimateCtrl.text,
                      //     "weight" : weightCtrl.text,
                      //     // "comment" : commentCtrl.text
                      //   };
                      //   // CommonMethods.commonPostApiData(ApiInterface.UPDATE_DAILY_TRAINING+widget.dailyTrainDatum.id+'/'+userId, updateMap).then((value){
                      //   //   String mResponse = value.toString();
                      //   //   Map responseMap = json.decode(mResponse);
                      //   //   String mStatus = responseMap['status'];
                      //   //   String message = responseMap['msg'];
                      //   //   if(mStatus == 'success'){
                      //   //     CommonMethods.getDialoge(message,intTitle: 2,voidCallback: (){
                      //   //       Get.back();
                      //   //       Get.back();
                      //   //     });
                      //   //   }
                      //   //   else if(mStatus == 'error'){
                      //   //     CommonMethods.getDialoge(message,intTitle: 1,voidCallback: (){
                      //   //       Get.back();
                      //   //     });
                      //   //   }
                      //   // });
                      // }),
                      // const SizedBox(height: 20.0,),
                    ],
                  );
                },
              ),
            ),
          ],),
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