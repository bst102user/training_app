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
  final List dailyTrainDatum;
  final List otherTopData;
  DatlyTrainingEdit(this.dailyTrainDatum, this.otherTopData);
  DatlyTrainingEditState createState() => DatlyTrainingEditState();
}

class DatlyTrainingEditState extends State<DatlyTrainingEdit>{
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


      wattCtrl[i].text = (aPowWatt.isEmpty)?widget.dailyTrainDatum[i].powerWatt:aPowWatt;
      pulseCtrl[i].text = (aMaxPulse.isEmpty)?widget.dailyTrainDatum[i].pulse:aMaxPulse;
      avgPower[i].text = (aAvgPow.isEmpty)?widget.dailyTrainDatum[i].aAveragePower:aAvgPow;
      timeEstimateCtrl[i].text = (aEstimate.isEmpty)?widget.dailyTrainDatum[i].trainingstimeMin:aEstimate;
      codenceCtrl[i].text = (aCodence.isEmpty)?widget.dailyTrainDatum[i].cadence:aCodence;
      breakCtrl[i].text = (aBreak.isEmpty)?widget.dailyTrainDatum[i].breaks:aBreak;
      // minTimeCtrl[i].text = (aMinTime==null||aMinTime.isEmpty)?'0':aMinTime;

      ratingList[i] = widget.dailyTrainDatum[i].aRating;
    }
    weightUpCtrl.text = widget.otherTopData[0].aWeight;
    trainingEstimateCtrl.text = widget.otherTopData[0].totalTrainingstime;
    commentCtrl.text = widget.otherTopData[0].aComment;
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
        'rating' : ratingList[i],
        'breaks' : breakCtrl[i].text,
        'time_min' : timeEstimateCtrl[i].text,
        'row_id' : widget.dailyTrainDatum[i].id
      };
      allIntervalMap.add(innerMap);
    }
    Map outerMap = {
      'Weight' : weightUpCtrl.text,
      'comment' : commentCtrl.text,
      'Trainings_time_min' : trainingEstimateCtrl.text,
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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
                          'edit training'.toUpperCase(),
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
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.line_weight,
                              mTitle: 'Weight',
                              keybordType: TextInputType.text,
                              mController: weightUpCtrl
                          ),
                          const SizedBox(height: 10.0,),
                          Text('Total training time',
                            style: GoogleFonts.roboto(
                                color: Colors.white
                            ),),
                          CommonWidgets.commonTextField(
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.watch_later,
                              mTitle: 'Training Estimate Time',
                              keybordType: TextInputType.text,
                              mController: trainingEstimateCtrl
                          ),
                          const SizedBox(height: 10.0,),
                          Text('Comment',
                            style: GoogleFonts.roboto(
                                color: Colors.white
                            ),),
                          CommonWidgets.commonTextField(
                              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                              mIcon: Icons.comment,
                              mTitle: 'Comment',
                              keybordType: TextInputType.text,
                              mController: commentCtrl
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
                                  'Trainings Time',
                                  style: GoogleFonts.roboto(
                                      color: CommonVar.RED_BUTTON_COLOR
                                  ),
                                ),
                                CommonWidgets.commonTextField(
                                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                                    mTitle: 'Trainings Time',
                                    shouldPreIcon: false,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    mController: timeEstimateCtrl[index],
                                    hintColor: Colors.grey
                                ),
                                const SizedBox(height: 10.0,),

                                RatingBar.builder(
                                  unratedColor: Colors.white,
                                  initialRating: isNumeric(widget.dailyTrainDatum[index].aRating)?double.parse(widget.dailyTrainDatum[index].aRating==null?'0.0':widget.dailyTrainDatum[index].aRating):0.0,
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
                                    ratingList[index] = rating.toString();
                                  },
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
                                            mTitle: 'Break',
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