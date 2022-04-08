import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';

class ForgetPassword extends StatefulWidget{
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword>{
  TextEditingController emailController = TextEditingController();
  forgetPassword()async{
    if(emailController.text.isEmpty){
      CommonMethods.getDialoge('Please enter email',voidCallback: (){
        Get.back();
      });
    }
    else if(!CommonMethods.isEmailValid(emailController.text)){
      CommonMethods.getDialoge('Pleas enter valid email',voidCallback: (){
        Get.back();
      });
    }
    else {
      Map forgetMap = {
        "email": emailController.text,
      };
      CommonMethods.commonPostApiData(ApiInterface.FORGET_PASSWORD, forgetMap).then((response){
        Map mMap = json.decode(response.data);
        var status = mMap['status'];
        if(status == 'error'){
          CommonMethods.getDialoge('Email is incorrect',voidCallback: (){
            Get.back();
          });
        }
        else if(status == 'success'){
          CommonMethods.getDialoge('We have sent one link on your email address to reset your password',voidCallback: (){
            Get.back();
          });
        }
      });
    }
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(
                "assets/images/cycle_up.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forget Password'.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white
                      ),
                    ),
                    CommonWidgets.mHeightSizeBox(),
                    CommonWidgets.commonTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.email,
                        mTitle: 'Email',
                        mController: emailController
                    ),
                  ],
                ),
                CommonWidgets.commonButton('RESET PIN',(){
                  forgetPassword();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}