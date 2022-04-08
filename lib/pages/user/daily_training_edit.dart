import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/daily_training_model.dart';

class DatlyTrainingEdit extends StatefulWidget{
  final DailyTrainDatum dailyTrainDatum;
  DatlyTrainingEdit(this.dailyTrainDatum);
  DatlyTrainingEditState createState() => DatlyTrainingEditState();
}

class DatlyTrainingEditState extends State<DatlyTrainingEdit>{
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController timeCtrl = TextEditingController();
  TextEditingController time1Ctrl = TextEditingController();
  TextEditingController wayCtrl = TextEditingController();
  TextEditingController pulseCtrl = TextEditingController();
  TextEditingController codenseCtrl = TextEditingController();
  TextEditingController ipsmmCtrl = TextEditingController();
  TextEditingController dolariopCtrl = TextEditingController();
  Widget mReturnWigdet = Container();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weightCtrl.text = widget.dailyTrainDatum.powerWatt;
    time1Ctrl.text = widget.dailyTrainDatum.rainingstime;
    wayCtrl.text = widget.dailyTrainDatum.powerWatt;
    pulseCtrl.text = widget.dailyTrainDatum.pulse;
    codenseCtrl.text = widget.dailyTrainDatum.cadence;
    ipsmmCtrl.text = widget.dailyTrainDatum.powerWatt;
    dolariopCtrl.text = widget.dailyTrainDatum.powerWatt;
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
          child: ListView(children: [
            CommonWidgets.commonHeader(context, 'Edit Training'),
            const SizedBox(height: 30.0,),
            CommonWidgets.commonTextField(
              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
              mTitle: 'Weight',
              shouldPreIcon: false,
              contentPadding: const EdgeInsets.all(10.0),
              mController: weightCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
              mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
              mTitle: 'Time',
              shouldPreIcon: false,
              contentPadding: const EdgeInsets.all(10.0),
              mController: timeCtrl
            ),
            const SizedBox(height: 10.0,),
            const Divider(
              thickness: 0.5,
              color: Colors.white,
            ),
            Text(
              'Interval 1',
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 15.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Time',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: timeCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Way',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: wayCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Pulse',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: pulseCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Codense',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: codenseCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Ipsmm',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: ipsmmCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Dolariop',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: dolariopCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Time',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: timeCtrl
            ),
            const SizedBox(height: 10.0,),
            CommonWidgets.commonTextField(
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: 'Time',
                shouldPreIcon: false,
                contentPadding: const EdgeInsets.all(10.0),
                mController: timeCtrl
            ),
            const SizedBox(height: 10.0,),
          Center(
            child: Column(
              children: [
                Text(
                  'Rate',
                  style: GoogleFonts.roboto(
                      fontSize: 20.0,
                      color: CommonVar.RED_BUTTON_COLOR,
                      fontWeight: FontWeight.w600
                  ),
                ),
                RatingBar.builder(
                  unratedColor: Colors.white,
                  initialRating: 0,
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
                  },
                ),
              ],
            ),
          ),
            const SizedBox(height: 20.0,),
            CommonWidgets.commonButton('Save', () {
              Map updateMap = {
                "weight" : weightCtrl.text,
                "dr_time" : time1Ctrl.text,
                "intervals" : time1Ctrl.text,
                "way" : wayCtrl.text,
                "pulse" : pulseCtrl.text,
                "condense" : codenseCtrl.text,
                "ipsmm"  : ipsmmCtrl.text,
                "dolriop" : dolariopCtrl.text
              };
              CommonMethods.commonPostApiData(ApiInterface.UPDATE_DAILY_TRAINING+widget.dailyTrainDatum.id, updateMap).then((value){
                String mResponse = value.toString();
                Map responseMap = json.decode(mResponse);
                String mStatus = responseMap['status'];
                String message = responseMap['msg'];
                if(mStatus == 'success'){
                  CommonMethods.getDialoge(message,intTitle: 2,voidCallback: (){
                    Get.back();
                    Get.back();
                  });
                }
                else if(mStatus == 'error'){
                  CommonMethods.getDialoge(message,intTitle: 1,voidCallback: (){
                    Get.back();
                  });
                }
              });
            }),
            const SizedBox(height: 20.0,)
          ],),
        ),
      ),
    );
  }

}