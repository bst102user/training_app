import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';

class EditProfile extends StatefulWidget{
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile>{
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  bool _passwordVisible = false;
  bool _conPasswordVisible = false;
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/profile_back.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
            child: ListView(
              children: [
                Text(
                  'Register',
                  style: GoogleFonts.roboto(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white
                  ),
                ),
                CommonWidgets.mHeightSizeBox(height: 25.0),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                  mIcon: Icons.person,
                  mTitle: 'Name'
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.email,
                    mTitle: 'Email'
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.passwordTextField(passController,passwordVisible:_passwordVisible,callback: (){
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                  mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.passwordTextField(conPassController,passwordVisible:_conPasswordVisible,callback: (){
                  setState(() {
                    _conPasswordVisible = !_conPasswordVisible;
                  });
                },
                label: 'Confirm Password',
                mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.phone,
                    mTitle: 'Mobile Number'
                ),
                CommonWidgets.mHeightSizeBox(),
                CommonWidgets.commonTextField(
                    mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                    mIcon: Icons.date_range,
                    mTitle: 'Birthday'
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: checkedValue,
                        checkColor: Colors.white,  // color of tick Mark
                        activeColor: CommonVar.RED_BUTTON_COLOR,
                        side: const BorderSide(
                          color: CommonVar.RED_BUTTON_COLOR, //your desire colour here
                          width: 1.5,
                        ),
                        onChanged: (value) {
                          setState(() {
                            checkedValue = !checkedValue;
                          });
                        }),
                    Text(
                      'Allow Notification',
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18.0
                      ),
                    ),
                  ],
                ),
                CommonWidgets.mHeightSizeBox(height: 20.0),
                CommonWidgets.commonButton('SAVE',(){})
              ],
            ),
          ),
        ),
      ),
    );
  }

}