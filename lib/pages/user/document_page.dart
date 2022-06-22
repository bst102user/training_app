import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_page.dart';
import 'package:path/path.dart';

class DocumentPage extends StatefulWidget{
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage>{
  String pdfUrl = '';

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Widget commonView(String label, String mUrl, String sendKey, {mCallback}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return InkWell(
      onTap: ()async{
        String userId = await CommonMethods.getUserId();
        Map sendMap = {
          "name" : sendKey
        };
        Response mResponse = await CommonMethods.commonPostApiData(ApiInterface.GET_DOCUMENT+userId,sendMap);
        String urlData = mResponse.data;
        Map resMap = json.decode(urlData);
        String url = resMap['data'];
        File _file = File(url);
        String _extenion = extension(_file.path);
        if(_extenion == ''){
          CommonMethods.showToast(this.context, 'No data found');
        }
        else if(_extenion == '.xls'||_extenion == '.xlsx'){
          _launchURL(url);
        }
        else {
          Get.to(PdfPage(label, url, _extenion));
        }
      },
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
                const Icon(
                  Icons.attach_file_outlined,
                  size: 20.0,
                  color: Colors.white,
                ),
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
              "assets/images/cycle_blur.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: ListView(
            children: [
              CommonWidgets.commonHeader(context, 'Documents'),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView('Name Proof',ApiInterface.SHOW_DOCUMENT,'name_proof'),
              commonView('Consectetur',ApiInterface.SHOW_DOCUMENT,'consectetur'),
              commonView('Adipiscing',ApiInterface.SHOW_DOCUMENT,'adipicing'),
              commonView('Sollicitudin Sapien',ApiInterface.SHOW_DOCUMENT,'sollicitudin_sapien'),
              commonView('Ullamcorper',ApiInterface.SHOW_DOCUMENT,'ullamcoper'),
              commonView('Pretium',ApiInterface.SHOW_DOCUMENT,'pretium'),
            ],
          ),
        ),
      ),
    );
  }

}