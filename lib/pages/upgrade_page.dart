import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_widgets.dart';

class UpgradePage extends StatefulWidget{
  UpgradePageState createState() => UpgradePageState();
}

class UpgradePageState extends State<UpgradePage>{
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
            children: [
              Image.asset(
                  'assets/images/upgrad_green.png',
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
                'upgrade'.toUpperCase(),
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600
                ),
              ),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              commonView('Actual Package'),
              commonView('Upgrade to Advance'),
            ],
          ),
        ),
      ),
    );
  }

}