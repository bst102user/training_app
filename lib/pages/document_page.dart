import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_widgets.dart';

class DocumentPage extends StatefulWidget{
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentPage>{

  Widget commonView(String label, {mCallback}){
    const borderSide = BorderSide(color: Colors.white, width: 0.5);
    return Container(
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
              Text(
                'documents'.toUpperCase(),
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600
                ),
              ),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView('Name Proof'),
              commonView('Consectetur'),
              commonView('Adipiscing'),
              commonView('Sollicitudin Sapien'),
              commonView('Ullamcorper'),
              commonView('Pretium'),
              commonView('Ullamcorper'),
              commonView('Pretium'),
            ],
          ),
        ),
      ),
    );
  }

}