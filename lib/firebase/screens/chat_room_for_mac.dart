import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/firebase/firebase_api.dart';
import 'package:training_app/firebase/keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';


class ChatRoomForMac extends StatefulWidget {
  ChatRoomForMacState createState() => ChatRoomForMacState();
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  final bool isSetNavigation;
  ChatRoomForMac({required this.chatRoomId, required this.userMap, required this.isSetNavigation});
}

class ChatRoomForMacState extends State<ChatRoomForMac>{
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _controller = ScrollController();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  File? imageFile;
  File? file;
  UploadTask? task;
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // registerNotification();
    // configLocalNotification();
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      rotate: 0,
    );
    print(file.lengthSync());
    return result!;
  }

  void generateFileToUrl(BuildContext context,File imageFile) async{
    // Navigator.pop(context);
    // final picker = ImagePicker();
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // imageFile = File(pickedFile!.path);
    // final dir = await path_provider.getTemporaryDirectory();
    // final tempTargetPath = dir.absolute.path + "/temp.jpg";
    // File compressFile = await testCompressAndGetFile(imageFile, tempTargetPath);
    // String userId = await CommonMethods.getUserId();
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse('https://teamwebdevelopers.com/sportsfood/api/image/6'));
    var pic = await http.MultipartFile.fromPath("sendimage", imageFile.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    setState(() {
      load = false;
    });
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    _message.text = responseString;
  }



  void configLocalNotification() {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettingsMacOS = const MacOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
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
  void showNotification(message) async {
    // var message = {'title':'ii','body':'yyyy'};
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
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }


  Future selectFile() async {
    load = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],);

    print('Download-Link: $result');
    if (result == null) return;
    final path = result.files.single.path!;
    print('path $path');
    // setState(() => file = File(path));
    setState(() {
      file = File(path);
      imageFile = File(result.files.single.path!);
      generateFileToUrl(this.context, file!);
    });
    // if(imageFile!.path.split('.').last == 'jpeg'||imageFile!.path.split('.').last == 'jpg'||imageFile!.path.split('.').last == 'png'){
    //   load = false;
    //   uploadImage();
    // }
    // else{
    //   final fileName = basename(file!.path);
    //   final destination = 'files/$fileName';
    //   print('fileName $fileName');
    //   task = FirebaseApi.uploadFile(destination, file!);
    //   setState(() {});
    //   print('task $task');
    //   if (task == null) return;
    //
    //   final snapshot = await task!.whenComplete(() {});
    //   final urlDownload = await snapshot.ref.getDownloadURL();
    //
    //   print('Download-Linkmmmm: $urlDownload');
    //   setState(() {
    //     load = false;
    //   });
    //   _message.text = urlDownload;
    //   onSendMessage();
    // }
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }


  Future uploadImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],);

    print('Download-Link: $result');
    if (result == null) return;
    final path = result.files.single.path!;
    print('path $path');
    // setState(() => file = File(path));
    setState(() {
      file = File(path);
      imageFile = File(result.files.single.path!);
    });


    String fileName = const Uuid().v1();
    int status = 1;

    if(imageFile!.path.split('.').last == 'jpeg'||imageFile!.path.split('.').last == 'jpg'||imageFile!.path.split('.').last == 'png'){
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .set({
        "sendby": _auth.currentUser!.uid,
        "message": "",
        "type": "img",
        "time": FieldValue.serverTimestamp(),
      });
      var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

      var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .doc(fileName)
            .delete();

        status = 0;
      });

      if (status == 1) {
        String imageUrl = await uploadTask.ref.getDownloadURL();

        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .doc(fileName)
            .update({"message": imageUrl});

        print('lllllll'+imageUrl);
      }
    }
    else{
      load = false;
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      print('fileName $fileName');
      task = FirebaseApi.uploadFile(destination, file!);
      setState(() {});
      print('task $task');
      if (task == null) return;

      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      print('Download-Linkmmmm: $urlDownload');
      setState(() {
        load = false;
      });
      _message.text = urlDownload;
      onSendMessage();
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Timer(
        const Duration(seconds: 1),
            () => _controller.jumpTo(_controller.position.maxScrollExtent),
      );
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      sendAndRetrieveMessage(widget.userMap['auth_token']);
      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    Uri mUri = Uri.parse(url);
    var res = await http.post(
      mUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$MY_SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _message.text,
            'title': _auth.currentUser!.displayName
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'room_id' : widget.chatRoomId,
            'user_map' : widget.userMap,
            'navigate' : 'chat'
          },
          'to': token,
        },
      ),
    );

    print(res);
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


  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator =load? Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: const Padding(padding: EdgeInsets.all(5.0),child: Center(child: CircularProgressIndicator())),
    ):Container();
    Timer(
      const Duration(seconds: 1),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
    final size = MediaQuery.of(context).size;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: CommonVar.BLACK_TEXT_FIELD_COLOR,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  // color: Colors.red,
                  height: 55.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream:
                        _firestore.collection("users").doc(widget.userMap['uid']).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10.0,),
                                  (widget.userMap['user_type']!='trainer' && widget.isSetNavigation)?InkWell(
                                    onTap: ()=>Navigator.pop(context),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ):Container(),
                                  const SizedBox(width: 10.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.userMap['name']+' '+widget.userMap['lname'],
                                        style: GoogleFonts.roboto(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                        ),),
                                      Text(
                                        snapshot.data!['status'],
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 12.0
                                        ),
                                      ),
                                      const Divider(
                                        color: CommonVar.RED_BUTTON_COLOR,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(widget.chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 85.0),
                        child: Container(
                          height: screenHeight*0.8,
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> map = snapshot.data!.docs[index]
                                  .data() as Map<String, dynamic>;
                              return messages(size, map, context);
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: size.width / 1.3,
                          child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: _message,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Type a message..',
                                hintStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300, // light
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white// italic
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => uploadImage(),
                                  icon: const Icon(
                                    Icons.attach_file,
                                    color: Colors.white,),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(width: 1,color: Colors.white),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(width: 1,color: Colors.white),
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(width: 1,)
                                ),
                              )
                          ),
                        ),
                        const SizedBox(width: 20.0,),
                        InkWell(
                          onTap: onSendMessage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CommonVar.RED_BUTTON_COLOR,
                            ),
                            child: Image.asset(
                              'assets/images/chat_arow.png',
                              color: Colors.white,
                              height: 25.0,
                              width: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(child: loadingIndicator)
            ],
          ),
        ),
      ),
    );
  }

  String readTimestamp(Timestamp mMon) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    int timestamp = mMon.microsecondsSinceEpoch==null?0:mMon.microsecondsSinceEpoch;
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'day ago';
      } else {
        time = diff.inDays.toString() + 'days ago';
      }
    }

    return time;
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 5.0,bottom: 5.0,left: map['sendby'] == _auth.currentUser!.uid?20.0:10.0,right: map['sendby'] == _auth.currentUser!.uid?10.0:20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: map['sendby'] == _auth.currentUser!.uid?const Radius.circular(0.0):const Radius.circular(10.0),
                bottomLeft: map['sendby'] == _auth.currentUser!.uid?const Radius.circular(10.0):const Radius.circular(0.0),
              )   ,
              // borderRadius: BorderRadius.circular(20),
              color: map['sendby'] == _auth.currentUser!.uid?const Color(0xffcea332):const Color(0xff41bdd5),
            ),
            child: InkWell(
              onTap: (){
                if(Uri.parse(map['message']).host != ''){
                  _launchURL(map['message']);
                }
              },
              child: Text(
                map['message'],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  decoration: Uri.parse(map['message']).host == '' ? TextDecoration.none:TextDecoration.underline,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: map['sendby'] == _auth.currentUser!.uid?20:10, right: 5.0, bottom: 10.0),
            child: Text(//mList.docs[index].data()['time']
              readTimestamp(map['time']),
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 10.0
              ),
            ),
          )
        ],
      ),
    )
        : Container(
      height: size.height / 2.5,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map['sendby'] == _auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowImage(
              imageUrl: map['message'],
            ),
          ),
        ),
        child: Container(
          height: size.height / 2.5,
          width: size.width / 2,
          decoration: BoxDecoration(border: Border.all()),
          alignment: map['message'] != "" ? null : Alignment.center,
          child: map['message'] != ""
              ? Image.network(
            map['message'],
            fit: BoxFit.cover,
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}