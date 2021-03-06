import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/firebase/firebase_api.dart';
import 'package:training_app/firebase/keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';

class ChatRoom extends StatefulWidget {
  ChatRoomState createState() => ChatRoomState();
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final bool isSetNavigation;
  ChatRoom({required this.chatRoomId, required this.userMap, required this.isSetNavigation});
}

class ChatRoomState extends State<ChatRoom>{
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

  void configLocalNotification() {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
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

  Future<String> getNames(String key)async{
    SharedPreferences mPref = await SharedPreferences.getInstance();
    return mPref.getString(key) as String;
  }

  Future selectFile() async {
    load = true;
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    setState(() {
      load = false;
    });
    _message.text = urlDownload;
    onSendMessage();
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  uploadFiles(File files)async{
    CommonMethods.showAlertDialog(this.context);
    var postUri = Uri.parse(ApiInterface.UPLOAD_XLS_FILE);
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'sendfile', files.path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(this.context);
      CommonMethods.showToast(this.context, 'Files uploaded');
      Navigator.pop(this.context);
    }
  }

  void showDialogWithFields() {
    showDialog(
      context: this.context,
      builder: (_) {
        return AlertDialog(
          title: Text('Choose file type'),
          content: Container(
            height: 100.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    getImage();
                    Navigator.pop(this.context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Select image'),
                  ),
                ),
                InkWell(
                  onTap: (){
                    selectFile();
                    Navigator.pop(this.context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Select File'),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(this.context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
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
    var ref2 = FirebaseStorage.instance.ref().child('files').child("$fileName.pdf");

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
      sendAndRetrieveMessage(widget.userMap['auth_token']);
      print(imageUrl);
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
    // Map<String, dynamic> toUserMap = {
    //   'name' : widget.userMap['name'],
    //   'lname' : widget.userMap['lname'],
    // };
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String fName = mPref.getString('user_fname') as String;
    String lName = mPref.getString('user_lname') as String;
    widget.userMap['name'] = fName;
    widget.userMap['lname'] = lName;
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
    _message.clear();
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
                                      FutureBuilder(
                                        future: getNames('ch_fname'),
                                        builder: (context, namesnap){
                                          if(snapshot.data == null){
                                            return Text('');
                                          }
                                          else{
                                            return FutureBuilder(
                                              future: getNames('ch_lname'),
                                              builder: (context,lnamesnap){
                                                if(lnamesnap.data==null){
                                                  return Text('');
                                                }
                                                else{
                                                  return Text(namesnap.data.toString()+' '+lnamesnap.data.toString(),
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white
                                                    ),);
                                                }
                                              },
                                            );
                                          }
                                        },
                                      ),

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
                                onPressed: () => showDialogWithFields(),
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
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                  'assets/images/chat_arow.png',
                                color: Colors.white,
                                height: 25.0,
                                width: 25.0,
                              ),
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

  Future<String> readTimestamp(Timestamp mMon)async {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    int timestamp = await mMon.microsecondsSinceEpoch==null?0:mMon.microsecondsSinceEpoch;
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
          FutureBuilder(
            future: readTimestamp(map['time']),
            builder: (context, snapshot){
              if(snapshot.data == null){
                return Text('');
              }
              else{
                // return Text(snapshot.data as String);
                return Padding(
                  padding: EdgeInsets.only(left: map['sendby'] == _auth.currentUser!.uid?20:10, right: 5.0, bottom: 10.0),
                  child: Text(//mList.docs[index].data()['time']
                    snapshot.data as String,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 10.0
                    ),
                  ),
                );
              }
            },
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

//