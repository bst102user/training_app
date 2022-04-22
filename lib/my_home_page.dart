import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _textController = TextEditingController();

  String iOSDevice = 'fR17YmHZTVCMNFfM3HJEnH:APA91bEwAfoDvuA4G4ouQEavwxmI16igoU4Qcmm8CEieXxngE3VDPXM9psHMrqwUccWEfGVJ5maAKOZfDS_EsfXmaVbpaIqrFm9VV4JbC8aBy6Q49ZUkAEZYDn420C7qpoZ16jdGJhu-';
  String androidSimul = 'fHsAgIoUQeelqgioMhQ4eW:APA91bGJKewTrmE9TjmhZrAe_3Sb9cNvl5fqB1aChSW6snov5ufIY9mfQ4DhPplQ2O7KweOcmLJF1dI9dVpd_w8cSWmH8S0HBUMQMyAmurMPDkl-2J7ISrD3TfDlx_AWpyCeqJzGxVGG';

  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    // }
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    // );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Get Token',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                _firebaseMessaging.getToken().then((val) {
                  print('Token: '+val!);
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 260,
              child: TextFormField(
                validator: (input) {
                  if(input!.isEmpty) {
                    return 'Please type an message';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Message'
                ),
                controller: _textController,
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Send a message to Android',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                sendAndRetrieveMessage(androidSimul);
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Send a message to iOS',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                sendAndRetrieveMessage(iOSDevice);
              },
            )
          ],
        ),
      ),
    );
  }

  final String serverToken = 'AAAAFs5KxUM:APA91bFz2vYR4J0qG4D24-vvU1pBnMjZ73AVWizDQHVBC4WwjLzjYkOgIGH5tTdyaT_o_HcyX-yubZOP8buokqwAjmJb_Sc6auJ7RGZ2syW6oaIpEoQGu4JMGQUWXKV9agdsXRyNqY3j';

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    Uri mUri = Uri.parse(url);
    var res = await http.post(
      mUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _textController.text,
            'title': 'FlutterCloudMessage'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    print(res);

    _textController.text = '';
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(message);
      }
    });

    return completer.future;
  }
}