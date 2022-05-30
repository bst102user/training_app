// ignore_for_file: avoid_print

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
import 'package:training_app/models/all_race_model.dart';

class AddRace extends StatefulWidget{
  final dynamic canData;
  AddRace(this.canData);
  AddRaceState createState() => AddRaceState();
}

class AddRaceState extends State<AddRace>{
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController distanceCtrl = TextEditingController();
  TextEditingController verMetCtrl = TextEditingController();
  TextEditingController goalCtrl = TextEditingController();
  TextEditingController priorityCtrl = TextEditingController();
  TextEditingController arrivalCtrl = TextEditingController();
  String firstDayStr='First Day',lastDayStr='Last Day',departureStr='Departure',arrivalStr='Arrival';
  bool isFirstDay = true;
  DateTime selectedDate = DateTime.now();
  String titleStr = '';
  String buttonName = '';


  addOrUpdateRace(String keyUrl){
    if(nameCtrl.text.isEmpty||distanceCtrl.text.isEmpty||verMetCtrl.text.isEmpty
        ||goalCtrl.text.isEmpty||priorityCtrl.text.isEmpty||(arrivalStr=='Arrival')||
    firstDayStr=='First Day'||departureStr=='Last Day'){
      CommonMethods.getDialoge('All fields are mandatory',voidCallback: (){
        Get.back();
      });
    }
    else {
      CommonMethods.showAlertDialog(context);
      Map addRaceMap = {
        "name": nameCtrl.text,
        "first_day" : firstDayStr,
        "last_day"  : lastDayStr,
        "distance": distanceCtrl.text,
        "vertical_meters": verMetCtrl.text,
        "goal": goalCtrl.text,
        "priority": priorityCtrl.text,
        "arrival" : arrivalStr,
        "departure" : departureStr,
      };

      CommonMethods.commonPostApiData(keyUrl, addRaceMap).then((
          response) {
        Get.back();
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
          CommonMethods.getDialoge(widget.canData==""?'Race added successfully':'Race updated successfully',intTitle: 2,voidCallback: (){
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
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        print(selectedDate);
        if(isFirstDay){
          firstDayStr = DateFormat('yyyy-MM-dd').format(selectedDate);
        }
        else{
          if(firstDayStr=='First Day'){
            CommonMethods.showToast(context, 'Select start date first');
          }
          else{
            lastDayStr = DateFormat('yyyy-MM-dd').format(selectedDate);
            if(lastDayStr != 'Last Day'){
              DateTime fDateTime = DateFormat('yyyy-MM-dd').parse(firstDayStr);
              DateTime lDateTime = DateFormat('yyyy-MM-dd').parse(lastDayStr);
              int differenceInDays = lDateTime.difference(fDateTime).inDays;
              if(differenceInDays<0){
                CommonMethods.getDialoge('Last date should be greater then first date',voidCallback: (){
                  setState(() {
                    lastDayStr = 'Last Day';
                  });
                  Get.back();
                });
              }
            }
          }
        }
      });
    }
  }

  _selectDeparture(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        print(selectedDate);
        departureStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  _selectArrival(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        print(selectedDate);
        arrivalStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.canData!=""){
      titleStr = 'update race';
      buttonName = 'UPDATE';
      nameCtrl.text = widget.canData.name;
      distanceCtrl.text = widget.canData.distance;
      verMetCtrl.text = widget.canData.verticalMeters;
      goalCtrl.text = widget.canData.goal;
      priorityCtrl.text = widget.canData.priority;
      arrivalStr = widget.canData.arrival;
      departureStr = widget.canData.departure;
      firstDayStr = widget.canData.firstDay;
      lastDayStr = widget.canData.lastDay;
    }
    else{
      titleStr = 'Add race';
      buttonName = 'SAVE';
    }
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
                CommonWidgets.commonHeader(context,titleStr),
                CommonWidgets.mHeightSizeBox(height: 25.0),
                CommonWidgets.commonTextField(
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                  mIcon: Icons.person,
                  mTitle: 'Name',
                  mController: nameCtrl,
                  keybordType: TextInputType.text,
                  mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: firstDayStr,
                    callBack: (){
                      isFirstDay = true;
                      _selectDate(context);
                    },
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: lastDayStr,
                    callBack: (){
                      isFirstDay = false;
                      _selectDate(context);
                    },
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.edit_road,
                    mTitle: 'Distance',
                    mController: distanceCtrl,
                    keybordType: TextInputType.number,
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.merge_type,
                    mTitle: 'Vertical Meter',
                    mController: verMetCtrl,
                    keybordType: TextInputType.number,
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.grade_outlined,
                    mTitle: 'Goal',
                    mController: goalCtrl,
                    keybordType: TextInputType.text,
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.priority_high,
                    mTitle: 'Priority',
                    mController: priorityCtrl,
                    keybordType: TextInputType.text,
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: arrivalStr,
                    callBack: (){
                      // isFirstDay = true;
                      _selectArrival(context);
                    },
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: departureStr,
                    callBack: (){
                      isFirstDay = true;
                      _selectDeparture(context);
                    },
                    mHeight: MediaQuery.of(context).size.height*0.1
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.commonButton(buttonName,(){
                  if(widget.canData==""){
                    CommonMethods.getUserId().then((userId){
                      addOrUpdateRace(ApiInterface.ADD_RACE+'/'+userId);
                    });
                  }
                  else{
                    CommonMethods.getUserId().then((userId){
                      addOrUpdateRace(ApiInterface.UPDATE_RACE+'/'+widget.canData.id+'/'+userId);
                    });
                  }
                },
                mHeight: MediaQuery.of(context).size.height*0.07)
              ],
            ),
          ),
        ),
      ),
    );
  }
}