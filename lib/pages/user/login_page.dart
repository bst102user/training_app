import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/methods.dart';
import 'package:training_app/pages/trainer/tr_dashboard.dart';
import 'package:training_app/pages/user/forget_password.dart';
import 'nav_dashboard.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool checkedValue = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  loginData()async{
    if(emailController.text.isEmpty||passController.text.isEmpty){
      CommonMethods.getDialoge('Please enter email and password',intTitle: 1,voidCallback: (){
        Get.back();
      });
    }
    else if(!CommonMethods.isEmailValid(emailController.text)){
      CommonMethods.getDialoge('Pleas enter valid email',intTitle: 1,voidCallback: (){
        Get.back();
      });
    }
    else {
      String? token = await FirebaseMessaging.instance.getToken();
      CommonMethods.showAlertDialog(context);
      Map loginMap = {
        "email": emailController.text,
        "password": passController.text,
        "device_token" : token
      };
      CommonMethods.commonPostApiData(ApiInterface.LOGIN_USER, loginMap).then((response){
        Map mMap = json.decode(response.data);
        var status = mMap['status'];
        if(status == 'error'){
          Get.back();
          CommonMethods.getDialoge('Email or password is incorrect',intTitle: 1,voidCallback: (){
            Get.back();
          });
        }
        else if(status == 'success'){
          Get.back();
          logIn(emailController.text, passController.text).then((user){
            if(user==null){
              String userType = mMap['data']['type'];
              createAccount(mMap['data']['fname'], mMap['data']['lname'], mMap['data']['email'],
                  passController.text,
                  userType.toLowerCase(),userType == 'Trainer'?mMap['data']['id']:mMap['data']['parents']).then((registerUser){
                    if(registerUser!=null){
                      CommonMethods.showToast(context, 'Login success');
                      CommonMethods.saveBoolPref('is_login', true);
                      CommonMethods.saveStrPref('user_id', mMap['data']['id']);
                      CommonMethods.saveStrPref('user_email', mMap['data']['email']);
                      CommonMethods.saveStrPref('user_fname', mMap['data']['fname']);
                      CommonMethods.saveStrPref('user_lname', mMap['data']['lname']);
                      CommonMethods.saveStrPref('trainer_id', mMap['data']['parents']);
                      CommonMethods.saveStrPref('user_type', mMap['data']['type']);
                      String userType = mMap['data']['type'];
                      if(userType == 'Trainer'){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => TrDashboard()),
                                (Route<dynamic> route) => false);
                      }
                      else {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => NavDashboard()),
                                (Route<dynamic> route) => false);
                      }
                    }
              });
            }
            else{
              CommonMethods.showToast(context, 'Login success');
              CommonMethods.saveBoolPref('is_login', true);
              CommonMethods.saveStrPref('user_id', mMap['data']['id']);//7(128) and 90(admin) ids for trainers
              CommonMethods.saveStrPref('user_email', mMap['data']['email']);
              CommonMethods.saveStrPref('user_fname', mMap['data']['fname']);
              CommonMethods.saveStrPref('user_lname', mMap['data']['lname']);
              CommonMethods.saveStrPref('trainer_id', mMap['data']['parents']);
              CommonMethods.saveStrPref('user_type', mMap['data']['type']);
              String userType = mMap['data']['type'];
              if(userType == 'Trainer'){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => TrDashboard()),
                        (Route<dynamic> route) => false);
              }
              else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => NavDashboard()),
                        (Route<dynamic> route) => false);
              }
            }
          });
        }
      });
    }
  }

  Widget checkBoxTitleAfternoonOutdoor() {
    return Container(
        width:230,
        child: CheckboxListTile(
            checkColor: Colors.white,
            selectedTileColor: Colors.white,
            value: checkedValue,
            onChanged: (value){
              setState(() {
                checkedValue = !checkedValue;
              });
            },
            title: Text(
                'Remember Me',
              style: GoogleFonts.roboto(
                fontSize: 50.0
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: CommonVar.RED_BUTTON_COLOR));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        backgroundColor: CommonVar.BLACK_BG_BG_COLOR,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:70.0),
              child: Image.asset('assets/images/top_logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                height: CommonMethods.deviceHeight(context)*0.9,
                decoration: const BoxDecoration(
                  color: CommonVar.BLACK_BG_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Glad to\nmeet you again!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: CommonWidgets.commonTextField(
                                  mController:emailController,
                                  keybordType: TextInputType.emailAddress,
                                  mTitle: 'Email',
                                  mIcon: Icons.mail_outline,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CommonWidgets.passwordTextField(passController,passwordVisible:_passwordVisible,callback: (){
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                        'Remember Me',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,

                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ForgetPassword())
                                      );
                                    },
                                    child: Text(
                                      'Forget Password',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            CommonWidgets.commonButton(
                                'Login',
                                    (){
                                  loginData();
                                }
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: Text(
                                  'or',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white60,
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterPage())
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    'Create an Account',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
