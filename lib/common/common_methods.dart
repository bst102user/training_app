import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_animated/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_var.dart';

class CommonMethods{
  static double deviceWidth(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return width;
  }

  static double deviceHeight(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    return height;
  }

  static void showToast(BuildContext context, String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: CommonVar.RED_BUTTON_COLOR,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // static void showToast(BuildContext context, String message){
  //   Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  // }
  static bool isEmailValid(email){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static void getDialoge(String message,{intTitle,voidCallback}){
    Get.defaultDialog(
      title: intTitle==1?'Error':(intTitle==2?'Success':'Alert'),
      content: Text(message),
      confirm: InkWell(
          onTap: voidCallback,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Ok'),
          )
      ),
    );
  }

  static void saveBoolPref(String key, bool val)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    mPref.setBool(key,val);
  }

  static Future<bool?> getBoolPref(String key)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    bool? val = mPref.getBool(key);
    return val;
  }

  static void saveStrPref(String key, String val)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    mPref.setString(key,val);
  }

  static Future<String?> getStrPref(String key)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String? val = mPref.getString(key);
    return val;
  }

  static void twoButtonDialoge(BuildContext context, String title, String message, VoidCallback mCallback){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message
                  // "Would you like to logout from the Application?",
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
                      FlatButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                          child: const Text('Yes'),
                          onPressed: mCallback
                      ),
                    ])
              ],
            ),
          );
        });
  }

  static Future<dynamic> commonPostApiData(String url, Map mMap)async{
    Dio dio = new Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    try {
      var response = await Dio().post(url,data: json.encode(mMap));
      print(response);
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<dynamic> commonPutApiData(String url, Map mMap)async{
    Dio dio = new Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    try {
      var response = await Dio().put(url,data: json.encode(mMap));
      print(response);
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<dynamic> commonGetApiData(String url)async{
    Dio dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    try {
      var response = await Dio().get(url);
      print(response);
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<dynamic> commonDeleteRequest(String url,BuildContext context)async{
    showAlertDialog(context);
    Dio dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    try {
      var response = await Dio().delete(url);
      print(response);
      Get.back();
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<dynamic> getRequest(String url,BuildContext context) async {
    dynamic response;
    try {
      response = await Dio().get(url);
      // Get.back();
      print('response $response');
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }

  static void showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: LoadingBouncingLine(size: 30,),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      }
    );
  }

  static bool passwordValidation(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static Future<String> getUserId()async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String userId = mPref.getString('user_id') as String;
    return userId;
  }

}