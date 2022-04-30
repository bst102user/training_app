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
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  ChatRoom({required this.chatRoomId, required this.userMap});
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // registerNotification();
    // configLocalNotification();
  }

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
      "sendby": _auth.currentUser!.displayName,
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
        "sendby": _auth.currentUser!.displayName,
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cycle_blur.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  // color: Colors.red,
                  height: 50.0,
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
                                children: [
                                  const SizedBox(width: 30.0,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.userMap['name'],
                                        style: GoogleFonts.roboto(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                        ),),
                                      Text(
                                        snapshot.data!['status'],
                                        style: GoogleFonts.roboto(
                                            color: Colors.white
                                        ),
                                      ),
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
                        padding: const EdgeInsets.only(top: 50, bottom: 70.0),
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
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    height: 50.0,
                    width: size.width / 1.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height / 17,
                          width: size.width / 1.3,
                          child: TextField(
                            controller: _message,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Type a message..',
                              hintStyle: const TextStyle(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: () => showDialogWithFields(),
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: CommonVar.RED_BUTTON_COLOR,),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.all(16),
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 30.0,
                            ), onPressed: onSendMessage),
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

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: map['sendby'] == _auth.currentUser!.displayName?const Color(0xffcea332):const Color(0xff41bdd5),
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
    )
        : Container(
      height: size.height / 2.5,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map['sendby'] == _auth.currentUser!.displayName
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