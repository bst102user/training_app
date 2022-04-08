import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'pdf_page.dart';

class DocumentPage extends StatefulWidget{
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage>{
  String pdfUrl = '';

  Widget commonView(String label, String mUrl, {mCallback}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return InkWell(
      onTap: (){
        CommonMethods.getRequest(mUrl, context).then((value){
          Get.to(PdfPage(label, 'https://teamwebdevelopers.com/sportsfood/api/show_pdf/9/5'));
        });
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
        decoration: const BoxDecoration(
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
              CommonWidgets.commonHeader(context, 'documents'),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView('Name Proof',ApiInterface.SHOW_DOCUMENT),
              commonView('Consectetur',ApiInterface.SHOW_DOCUMENT),
              commonView('Adipiscing',ApiInterface.SHOW_DOCUMENT),
              commonView('Sollicitudin Sapien',ApiInterface.SHOW_DOCUMENT),
              commonView('Ullamcorper',ApiInterface.SHOW_DOCUMENT),
              commonView('Pretium',ApiInterface.SHOW_DOCUMENT),
              commonView('Ullamcorper',ApiInterface.SHOW_DOCUMENT),
              commonView('Pretium',ApiInterface.SHOW_DOCUMENT),
            ],
          ),
        ),
      ),
    );
  }

}