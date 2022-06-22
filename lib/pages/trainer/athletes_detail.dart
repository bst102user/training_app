import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/trainer/tr_assign_athletes_model.dart';
import 'package:training_app/pages/trainer/ath_last_training.dart';
import 'package:training_app/pages/trainer/athlete_races.dart';
import 'package:training_app/pages/trainer/export_page.dart';
import 'package:training_app/pages/trainer/import_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';

class AthletesDetail extends StatefulWidget{
  final AssignDatum athlDetail;
  AthletesDetail(this.athlDetail);
  AthletesDetailState createState() => AthletesDetailState();
}

class AthletesDetailState extends State<AthletesDetail>{

  uploadFiles(File files, String catName)async{
    CommonMethods.showAlertDialog(this.context);
    String userId = await CommonMethods.getUserId();
    var postUri = Uri.parse(ApiInterface.UPLOAD_DOCUMENT+widget.athlDetail.id);
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    request.fields['category'] = catName;
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('sendimage', files.path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if (response.statusCode == 200){
      Navigator.pop(this.context);
      CommonMethods.showToast(this.context, 'File uploaded successfully');
    }
  }

  checkFileTypeAndSize(String fileCatName)async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File file = File(result.files.single.path!);
      String fileNameFromPath = file.path;
      var lastSeparator = fileNameFromPath.lastIndexOf(Platform.pathSeparator);
      var newPath = fileNameFromPath.substring(0, lastSeparator + 1) + widget.athlDetail.id+context.extension(file.path);
      File fileToUpload = File(newPath);
      String fileType = context.extension(newPath);
      getFileSize(file.path, 1).then((value)async{
        if(fileType=='.xls'||fileType == '.xlsx'||fileType == '.jpeg'||fileType == '.jpg'||fileType == '.pdf'||fileType == '.png'){
          uploadFiles(file,fileCatName);
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

  Widget commonView(String label, {mCallback,isAttachIcon=true}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return InkWell(
      onTap: mCallback,
      child: Container(
        height: 70.0,
        decoration: const BoxDecoration(
          border: Border(
            bottom: borderSide,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 20.0,),
                    Text(
                      label,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                isAttachIcon?const Icon(
                  Icons.attach_file_outlined,
                  size: 20.0,
                  color: Colors.white,
                ):Container(),
              ],
            ),
          ],
        ),
      ),
    );
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
              CommonWidgets.commonHeader(context, widget.athlDetail.fname),
              CommonWidgets.mHeightSizeBox(height: 10.0),
              CommonWidgets.commonButton('Import', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportPage(widget.athlDetail))
                );
              }),
              const SizedBox(height: 10.0,),
              CommonWidgets.commonButton('Export', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImportPage(widget.athlDetail.id))
                );
              }),
              const SizedBox(height: 10.0,),
              CommonWidgets.commonButton('Last Training', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AthLastTraining(widget.athlDetail.id))
                );
              }),
              // commonView('Racing Calender',mCallback: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AthleteRaces(widget.athlDetail.id)));
              // },
              // isAttachIcon: false),
              const SizedBox(height: 10.0,),
              Center(
                  child: Text('Documents',
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                    ),)
              ),
              commonView('Name Proof',mCallback: (){
                checkFileTypeAndSize('name_proof');
              }),
              commonView('Consectetur',mCallback: (){
                checkFileTypeAndSize('consectetur');
              }),
              commonView('Adipicing',mCallback: (){
                checkFileTypeAndSize('adipicing');
              }),
              commonView('Sollicitudin Sapien',mCallback: (){
                checkFileTypeAndSize('sollicitudin_sapien');
              }),
              commonView('Ullamcoper',mCallback: (){
                checkFileTypeAndSize('ullamcoper');
              }),
              commonView('Pretium',mCallback: (){
                checkFileTypeAndSize('pretium');
              }),
            ],
          ),
        ),
      ),
    );
  }
}