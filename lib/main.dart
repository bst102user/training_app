import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_app/pages/user/test2.dart';
import 'package:training_app/splash_screen.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
// Widget? openView;
//
// void configLocalNotification() {
//   var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOS = const IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }
//
// void showNotification(String title, String message, String payload) async {
//   // var message = {'title':'ii','body':'yyyy'};
//   //json.decode(message.data['data'])['title'])
//   // var message = json.encode(mJson);
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
//     'Flutter chat demo',
//     playSound: true,
//     enableVibration: true,
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics /*androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics*/);
//   await flutterLocalNotificationsPlugin.show(
//       0, title,message, platformChannelSpecifics,
//       payload: payload);
// }

// void registerNotification() {
//   firebaseMessaging.requestPermission();
//   // message.notification.title
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('onMessage: $message');
//     try {
//       if (message.data != null) {
//         showNotification(
//             'Message From Sportfood' , message.data['message'],
//             message.messageId!);
//       }
//     }
//     catch(e){
//       showNotification(
//           (message.notification!.title).toString(), (message.notification!.body).toString(),
//           message.messageId!);
//     }
//     return;
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//     openView = ProfilePage();
//   });

  // FirebaseMessaging.instance.getInitialMessage().then((message){
  //   if (message != null) {
  //     openView = ProfilePage();
  //   }
  // });

  // firebaseMessaging.getToken().then((token) {
  //   print('push token: $token');
  //   if (token != null) {
  //     // homeProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, currentUserId, {'pushToken': token});
  //   }
  // }).catchError((err) {
  //   Fluttertoast.showToast(msg: err.message.toString());
  // });
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // configLocalNotification();
  // registerNotification();
  // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen()
      // home: Test2()
      // home: openView==null?SplashScreen():openView,
    );
  }
}
