import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ImportPage extends StatefulWidget{
  final String athleteId;
  ImportPage(this.athleteId);
  ImportPageState createState() => ImportPageState();
}

class ImportPageState extends State<ImportPage>{
  DateTime selectedDate = DateTime.now();
  String startDateStr = 'Start Date';
  String endDateStr = 'End Date';
  bool isStartDate = true;
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        if(isStartDate) {
          startDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
        }
        else{
          endDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
        }
      });
    }
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.xls'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void getImage(String startDate, String endDate) async{
    String userId = await CommonMethods.getUserId();
    var uri = Uri.parse(ApiInterface.GET_LINK_XLS+'/'+widget.athleteId);

    Map body = {
      "fdate" : startDate,
      "ldate" : endDate
    };
    try {
      final response = await http.post(uri,
          body: json.encode(body)
      );
      if(response.statusCode == 200){
        _launchURL(response.body);
      }
      else{
        CommonMethods.showToast(this.context, 'Something went wrong');
      }
      // Directory tempDir = Directory((await getExternalStorageDirectory())!.path + '/xlssss');
    }
    catch (value) {
      print(value);
    }
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
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
              CommonWidgets.commonHeader(context, 'Export'),
              const SizedBox(height: 20.0,),
              Text(
                  'Start date',
                style: GoogleFonts.roboto(
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 5.0,),
              CommonWidgets.containerLikeTextField(
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                mTitle: startDateStr,
                mIcon: Icons.calendar_today_outlined,
                callBack: (){
                    isStartDate = true;
                  _selectDate(context);
                }
              ),
              const SizedBox(height: 15.0,),
              Text(
                'End date',
                style: GoogleFonts.roboto(
                    color: Colors.white
                ),
              ),
              const SizedBox(height: 5.0,),
              CommonWidgets.containerLikeTextField(
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                  mTitle: endDateStr,
                  mIcon: Icons.calendar_today_outlined,
                  callBack: (){
                    isStartDate = false;
                    _selectDate(context);
                  }
              ),
              const SizedBox(height: 50.0,),
              CommonWidgets.commonButton('GO', ()async {
                if(startDateStr == 'Start Date'|| endDateStr == 'End Date'){
                  CommonMethods.showToast(context, 'Please select both the date');
                }
                else {
                  getImage(startDateStr, endDateStr);
                }
                // _launchURL();
              })
            ],
          ),
        ),
      ),
    );
  }

}