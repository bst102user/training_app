import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/trainer/tr_assign_athletes_model.dart';
import 'package:training_app/pages/trainer/export_page.dart';

class AthletesDetail extends StatelessWidget{
  final AssignDatum athlDetail;
  AthletesDetail(this.athlDetail);

  Widget commonView(String label, {mCallback}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return InkWell(
      // onTap: (){
      //   CommonMethods.getRequest(mUrl, context).then((value){
      //     Get.to(PdfPage(label, value.toString()));
      //   });
      // },
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
              "assets/images/tr_back.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: ListView(
            children: [
              CommonWidgets.commonHeader(context, athlDetail.fname),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              CommonWidgets.commonButton('Export', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportPage(athlDetail.id))
                );
              }),
              commonView('Racing Calender'),
              commonView('Documents'),
              commonView('Adipicing'),
              commonView('Pretium'),
            ],
          ),
        ),
      ),
    );
  }

}