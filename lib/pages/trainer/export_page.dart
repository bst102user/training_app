import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/keys.dart';
import 'package:training_app/models/trainer/tr_assign_athletes_model.dart';

class ExportPage extends StatefulWidget{
  final AssignDatum athleteId;
  ExportPage(this.athleteId);
  ExportPageState createState() => ExportPageState();
}

class ExportPageState extends State<ExportPage>{
  File? nameFile;
  int i = 0;
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  Future<dynamic> getData() async {
    String userToken = '';
    QuerySnapshot querySnapshot = await collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    for(int i=0;i<allData.length;i++){
      if(widget.athleteId.email == allData[i]['email']){
        userToken = allData[i]['auth_token'];
      }
    }
    return userToken;
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token,String title,String body) async {
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
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'navigate' : 'notification'
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

  uploadFiles(File files)async{
    CommonMethods.showAlertDialog(this.context);
    String userId = await CommonMethods.getUserId();
    var postUri = Uri.parse(ApiInterface.UPLOAD_XLS_FILE+'/'+widget.athleteId.id);
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'sendfile', files.path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(this.context);
      getData().then((value){
        sendAndRetrieveMessage(value,'Training Assigned','You have assigned new training data');
      });
      Map notifSendMap = {
        "title": "Training Assigned",
        "message": "You have assigned new training data"
      };
      Response myRes = await CommonMethods
          .commonPostApiData(
          ApiInterface.SEND_NOTIFICATIONS + widget.athleteId.id +
              '/' + userId, notifSendMap);
      print(myRes);
      CommonMethods.showToast(this.context, 'Files uploaded');
      Navigator.pop(this.context);
    }
  }

  checkFileTypeAndSize()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      String fileNameFromPath = file.path;
      var lastSeparator = fileNameFromPath.lastIndexOf(Platform.pathSeparator);
      var newPath = fileNameFromPath.substring(0, lastSeparator + 1) + widget.athleteId.id+context.extension(file.path);
      File fileToUpload = File(newPath);
      String fileType = context.extension(newPath);
      getFileSize(file.path, 1).then((value)async{
        if(fileType=='.xls'||fileType == '.xlsx'){
          setState(() {
            nameFile = file;
          });
        }
        else{
          CommonMethods.getDialoge('You can upload only .xls file type',intTitle: 1,voidCallback: (){
            Navigator.pop(this.context);
          });
        }
      });
    } else {
      // User canceled the picker
    }
  }

  Future getFileSize(String filepath, int decimals) async {
    var file = XFile(filepath);
    int bytes = await file.length();
    if (bytes <= 0) {
      return "0 B";
    }
    else {
      double sizeInDouble = bytes/1000;
      return double.parse(sizeInDouble.toStringAsFixed(2));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: Platform.isMacOS?const BoxDecoration(
          color: CommonVar.BLACK_BG_BG_COLOR,
        ):const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/tr_back.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: ListView(
            children: [
              CommonWidgets.commonHeader(context, 'Import'),
              const SizedBox(height: 20.0,),
              Container(
                height: MediaQuery.of(context).size.height*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        nameFile==null?'':nameFile!.path.split('/').last,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        checkFileTypeAndSize();
                      },
                      child: DottedBorder(
                        color: Colors.white,
                        strokeWidth: 1,
                        radius: const Radius.circular(5),
                        dashPattern: [6, 3, 2, 3],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                    Icons.cloud_download,
                                  size: 50.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10.0,),
                                Text(
                                  'Drag and Drop a File',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 25.0
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CommonWidgets.commonButton('Upload', () {
                      uploadFiles(nameFile!);
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}