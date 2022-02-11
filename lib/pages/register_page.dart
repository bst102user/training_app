import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/pages/dashboard.dart';
import 'package:training_app/pages/nav_dashboard.dart';

class RegisterPage extends StatefulWidget{
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>{
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  bool _passwordVisible = false;
  bool _conPasswordVisible = false;
  bool checkedValue = false;
  String dateStr = '';
  DateTime selectedDate = DateTime.now();
  String birthDate = 'Birthday';
  String phoneCode = '+1';

  registerData()async{
    if(emailController.text.isEmpty||passController.text.isEmpty
    ||nameController.text.isEmpty||conPassController.text.isEmpty
    ||mobileController.text.isEmpty||birthDate=='Birthday'){
      CommonMethods.showToast(context, 'All Fields Mandatory');
    }
    else if(!CommonMethods.isEmailValid(emailController.text)){
      CommonMethods.showToast(context, 'Pleas enter valid email');
    }
    else if(!CommonMethods.passwordValidation(passController.text)){
      CommonMethods.getDialoge('Password should include-\n1-8 digit length\n2-One upper case one lower case\n3-One special charecter\n4-One numeric value',voidCallback: (){
        Get.back();
      });
    }
    else if(passController.text!=conPassController.text){
      CommonMethods.showToast(context, 'Password and confirm password does not match');
    }
    else if(!CommonMethods.validateMobile(mobileController.text)){
      CommonMethods.showToast(context, 'Pleas enter valid mobile');
    }
    else {
      CommonMethods.showAlertDialog(context);
      Map registerMap = {
        "fname" : nameController.text,
        "lname" : lastnameController.text,
        "email" : emailController.text,
        "password" : passController.text,
        "cpassword" : conPassController.text,
        "phone" : phoneCode+mobileController.text,
        "dob" : birthDate
      };
      CommonMethods.commonPostApiData(ApiInterface.REGISTER_USER, registerMap).then((response){
        Get.back();
        Map mMap = json.decode(response.data);
        var status = mMap['status'];
        var message = mMap['msg'];
        if(status == 'error'){
          CommonMethods.getDialoge(message,voidCallback: (){
            Get.back();
          });
        }
        else if(status == 'success'){
          CommonMethods.saveStrPref('user_email', emailController.text);
          CommonMethods.saveStrPref('user_fname', nameController.text);
          CommonMethods.saveStrPref('user_lname', lastnameController.text);
          CommonMethods.getDialoge('Registered successfully');
          Get.to(NavDashboard());
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
        birthDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  showCountryCode(){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          phoneCode = "+"+country.phoneCode;
        });
      },
    );
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
                "assets/images/profile.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
            child: ListView(
              children: [
                Text(
                  'Register',
                  style: GoogleFonts.roboto(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
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
                CommonWidgets.passwordTextField(passController,passwordVisible:_passwordVisible,callback: (){
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.passwordTextField(conPassController,passwordVisible:_conPasswordVisible,callback: (){
                  setState(() {
                    _conPasswordVisible = !_conPasswordVisible;
                  });
                },
                  label: 'Confirm Password',
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.countryCodeContainer(
                  mController: mobileController,
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.phone,
                    mTitle: '',
                    mTitleText: phoneCode,
                    callBack: (){
                      FocusScope.of(context).unfocus();
                      showCountryCode();
                    }
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.containerLikeTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: birthDate,
                    callBack: (){
                      FocusScope.of(context).unfocus();
                      _selectDate(context);
                    }
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: checkedValue,
                        checkColor: Colors.white,  // color of tick Mark
                        activeColor: CommonVar.RED_BUTTON_COLOR,
                        side: const BorderSide(
                          color: CommonVar.RED_BUTTON_COLOR, //your desire colour here
                          width: 1.5,
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkedValue = !checkedValue;
                          });
                        }),
                    Text(
                      'Allow Notification',
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18.0
                      ),
                    ),
                  ],
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.commonButton('SAVE',(){
                  FocusScope.of(context).unfocus();
                  registerData();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}