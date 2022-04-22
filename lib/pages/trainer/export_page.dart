import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';

class ExportPage extends StatefulWidget{
  final String athleteId;
  ExportPage(this.athleteId);
  ExportPageState createState() => ExportPageState();
}

class ExportPageState extends State<ExportPage>{
  File? nameFile;
  int i =0;

  uploadFiles(File files)async{
    CommonMethods.showAlertDialog(this.context);
    var postUri = Uri.parse(ApiInterface.UPLOAD_XLS_FILE+'/'+widget.athleteId);
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

  checkFileTypeAndSize()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if(result != null) {
      File file = File(result.files.single.path!);
      String fileNameFromPath = file.path;
      var lastSeparator = fileNameFromPath.lastIndexOf(Platform.pathSeparator);
      var newPath = fileNameFromPath.substring(0, lastSeparator + 1) + widget.athleteId+context.extension(file.path);
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
        decoration: const BoxDecoration(
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
              CommonWidgets.commonHeader(context, 'Export'),
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