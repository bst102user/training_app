import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';

class AddRace extends StatefulWidget{
  AddRaceState createState() => AddRaceState();
}

class AddRaceState extends State<AddRace>{
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController distanceCtrl = TextEditingController();
  TextEditingController verMetCtrl = TextEditingController();
  TextEditingController goalCtrl = TextEditingController();
  TextEditingController priorityCtrl = TextEditingController();
  TextEditingController arrivalCtrl = TextEditingController();
  String firstDayStr='First Day',lastDayStr='Last Day';
  bool isFirstDay = true;
  DateTime selectedDate = DateTime.now();

  addRace(){
    if(nameCtrl.text.isEmpty||distanceCtrl.text.isEmpty||verMetCtrl.text.isEmpty
        ||goalCtrl.text.isEmpty||priorityCtrl.text.isEmpty||arrivalCtrl.text.isEmpty||
    firstDayStr=='First Day'||lastDayStr=='Last Day'){
      CommonMethods.getDialoge('All fields are mandatory',voidCallback: (){
        Get.back();
      });
    }
    else {
      Map addRaceMap = {
        "name": nameCtrl.text,
        "first_day": firstDayStr,
        "last_day": lastDayStr,
        "distance": distanceCtrl.text,
        "vertical_meters": verMetCtrl.text,
        "goal": goalCtrl.text,
        "priority": priorityCtrl.text,
        "arrival": arrivalCtrl.text
      };

      CommonMethods.commonPostApiData(ApiInterface.ADD_RACE, addRaceMap).then((
          response) {
        print(response);
        Map mMap = json.decode(response.data);
        var status = mMap['status'];
        var message = mMap['msg'];
        if (status == 'error') {
          CommonMethods.getDialoge(message,voidCallback: (){
            Get.back();
          });
        }
        else if (status == 'success') {
          CommonMethods.getDialoge('Race add successfully',intTitle: 2,voidCallback: (){
            Get.back();
            Get.back();
          });
        }
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        print(selectedDate);
        if(isFirstDay){
          firstDayStr = DateFormat('dd/MM/yyyy').format(selectedDate);
        }
        else{
          lastDayStr = DateFormat('dd/MM/yyyy').format(selectedDate);
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
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
                CommonWidgets.commonHeader(context,'Add Race'),
                CommonWidgets.mHeightSizeBox(height: 25.0),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.person,
                    mTitle: 'Name',
                  mController: nameCtrl,
                  keybordType: TextInputType.text
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: firstDayStr,
                    callBack: (){
                      isFirstDay = true;
                      _selectDate(context);
                    }
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: lastDayStr,
                    callBack: (){
                      isFirstDay = false;
                      _selectDate(context);
                    }
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.edit_road,
                    mTitle: 'Distance',
                    mController: distanceCtrl,
                    keybordType: TextInputType.number
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.merge_type,
                    mTitle: 'Vertical Meter',
                    mController: verMetCtrl,
                    keybordType: TextInputType.number
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.grade_outlined,
                    mTitle: 'Goal',
                    mController: goalCtrl,
                    keybordType: TextInputType.text
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.priority_high,
                    mTitle: 'Priority',
                    mController: priorityCtrl,
                    keybordType: TextInputType.text
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.share_arrival_time,
                    mTitle: 'Arrival',
                    mController: arrivalCtrl,
                    keybordType: TextInputType.text
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.commonButton('SAVE',(){
                  addRace();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

}