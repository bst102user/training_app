import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/firebase/screens/chat_room.dart';
import 'package:training_app/pages/trainer/notification_trainer.dart';
import 'package:training_app/pages/trainer/tr_dashboard.dart';
import 'package:training_app/pages/user/login_page.dart';
import 'package:training_app/pages/user/nav_dashboard.dart';
import 'package:training_app/pages/user/notification_page.dart';
import 'package:training_app/pages/user/profile_page.dart';

class SplashScreen extends StatefulWidget{
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void configLocalNotification() {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String title, String message, String payload) async {
    // var message = {'title':'ii','body':'yyyy'};
    //json.decode(message.data['data'])['title'])
    // var message = json.encode(mJson);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics /*androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics*/);
    await flutterLocalNotificationsPlugin.show(
        0, title,message, platformChannelSpecifics,
        payload: payload);
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();
    // message.notification.title
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      try {
        if (message.data != null) {
          showNotification(
              'Message From Sportfood' , message.data['message'],
              message.messageId!);
        }
      }
      catch(e){
        showNotification(
            (message.notification!.title).toString(), (message.notification!.body).toString(),
            message.messageId!);
      }
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
    });

    FirebaseMessaging.instance.getInitialMessage().then((message)async{
      if (message != null) {//message.data['room_id']  message.data['user_map']
        SharedPreferences mPref = await SharedPreferences.getInstance();
        bool snapshot = mPref.getBool('is_login') as bool;
        String userType = mPref.getString('user_type') as String;
        if(snapshot == null){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
        }
        else {
          if (!snapshot) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
          }
          else {
            if(message.data['navigate'] == 'notification') {
              if(userType == 'Trainer'){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => NotificationTrainer()),
                        (Route<dynamic> route) => false);
              }
              else{
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                        (Route<dynamic> route) => false);
              }
            }
            else{
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>
                      ChatRoom(chatRoomId: message.data['room_id'],
                          userMap: json.decode(message.data['user_map']))),
                      (Route<dynamic> route) => false);
            }
          }
        }
      }
      else{
        goToNextScreen();
      }
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        // homeProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, currentUserId, {'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  initState(){
    super.initState();
    configLocalNotification();
    registerNotification();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  goToNextScreen()async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    bool snapshot = mPref.getBool('is_login') as bool;
    String userType = mPref.getString('user_type') as String;
    Future.delayed(const Duration(seconds: 3), () {
      if(snapshot == null){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false);
      }
      else {
        if (!snapshot) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
        }
        else {
          if(userType == 'Trainer'){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => TrDashboard()),
                    (Route<dynamic> route) => false);
          }
          else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => NavDashboard()),
                    (Route<dynamic> route) => false);
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/load_icon.png'),
          )
        ],
      ),
    );
  }
  
}