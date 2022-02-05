import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/profile_model.dart';

class ProfilePage extends StatefulWidget{
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  String dateStr = '';
  DateTime selectedDate = DateTime.now();
  String birthDate = 'Birthday';
  bool isDataShown = true;
  List<ProfileDatum>? listData;

  Future<dynamic> getProfileData()async{
    // CommonMethods.showAlertDialog(context);
    Dio dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    // String userId = CommonMethods.getStrPref('user_id').toString();
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String str = mPref.getString('user_id').toString();
    try {
      var response = await Dio().get(ApiInterface.GET_PROFILE+str);
      print(response);
      // Get.back();
      setState(() {
        ProfileModel profileModel = profileModelFromJson(response.toString());
        listData = profileModel.data;
        nameController.text = listData![0].fname;
        lastnameController.text = listData![0].lname;
        emailController.text = listData![0].email;
        mobileController.text = listData![0].phone;
        birthDate = listData![0].dob;
      });
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  initState(){
    super.initState();
    getProfileData();
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
        birthDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  updateProfile()async{

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: CommonMethods.deviceHeight(context),
          width: CommonMethods.deviceWidth(context),
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(
                "assets/images/profile.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
            child: ListView(
              children: [
                CommonWidgets.commonHeader(context, 'profile'),
                CommonWidgets.mHeightSizeBox(height: 25.0),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.person,
                    mTitle: 'Name',
                    keybordType: TextInputType.text,
                    mController: nameController
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.person,
                    mTitle: 'Last Name',
                    keybordType: TextInputType.text,
                    mController: lastnameController
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.email,
                    mTitle: 'Email',
                    keybordType: TextInputType.emailAddress,
                    mController: emailController
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.phone,
                    mTitle: 'Mobile Number',
                    keybordType: TextInputType.number,
                    mController: mobileController
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: birthDate,
                    callBack: (){
                      _selectDate(context);
                    }
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.commonButton('SAVE',()async{
                  CommonMethods.showAlertDialog(context);
                  SharedPreferences mPref = await SharedPreferences.getInstance();
                  String userId = mPref.getString('user_id').toString();
                  Map mMap = {
                    "fname" : nameController.text,
                    "lname" : lastnameController.text,
                    "email" : emailController.text,
                    "phone" : mobileController.text,
                    "dob" : birthDate
                  };
                  CommonMethods.commonPutApiData(ApiInterface.UPDATE_PROFILE+userId, mMap).then((response){
                    print(response.toString());
                    Map mMap = json.decode(response.toString());
                    String status = mMap['status'];
                    String message = mMap['message'];
                    if(status == 'success'){
                      Get.back();
                      CommonMethods.getDialoge('Profile updated',intTitle: 2,voidCallback: (){
                        Get.back();
                        Get.back();
                      });
                    }
                    else{
                      CommonMethods.getDialoge(message,intTitle: 1);
                    }
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}