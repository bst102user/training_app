import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_app/common/common_var.dart';

class CommonWidgets{
  static Widget mHeightSizeBox({
    height = 15.0,
  }){
    return SizedBox(
      height: height,
    );
  }
  static Widget mWidthSizeBox({
    width = 15.0,
  }){
    return SizedBox(
      width: width,
    );
  }
  static Widget commonButton(String label,VoidCallback mCallback,{iconData}){
    return InkWell(
      onTap: mCallback,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: CommonVar.RED_BUTTON_COLOR,
          borderRadius: BorderRadius.all(
              Radius.circular(10)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                  iconData,
              color: Colors.white,),
            ),
            Center(
                child: Text(
                    label,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600
                  ),
                )
            ),
            Container(width: 20.0,)
          ],
        ),
      ),
    );
  }

  static Widget commonTextField({
        mColor = CommonVar.BLACK_TEXT_FIELD_COLOR,
        mIcon,
        mTitle = "Text",
        keybordType,
        shouldOpocity = 0.8,
        enterTextColor = Colors.white,
        mController,
        shouldPreIcon = true,
      }){
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: mColor.withOpacity(shouldOpocity),
        borderRadius: const BorderRadius.all(
            Radius.circular(10)
        ),
      ),
      child: TextField(
        controller: mController,
        keyboardType: keybordType,
        style: GoogleFonts.roboto(
          color: enterTextColor
        ),
        decoration: InputDecoration(
            prefixIcon: shouldPreIcon?Icon(
                mIcon,
              color: Colors.white,
            ):null,
            border: InputBorder.none,
            hintStyle: GoogleFonts.roboto(color: Colors.white),
            hintText: mTitle,
            fillColor: mColor),
      ),
    );
  }

  static Widget containerLikeTextField({
    mColor = CommonVar.BLACK_TEXT_FIELD_COLOR,
    mIcon = Icons.person,
    mTitle = "Text",
    shouldOpocity = 0.8,
    callBack,
    width = double.infinity
  }){
    return InkWell(
      onTap: callBack,
      child: Container(
        height: 50.0,
        width: width,
        decoration: BoxDecoration(
          color: mColor.withOpacity(shouldOpocity),
          borderRadius: const BorderRadius.all(
              Radius.circular(10)
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15.0,),
            Center(
              child: Icon(
                  mIcon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 15.0,),
            Text(
              mTitle,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 17.0
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget countryCodeContainer({
    mColor = CommonVar.BLACK_TEXT_FIELD_COLOR,
    mIcon = Icons.person,
    mTitle = "Text",
    mTitleText,
    shouldOpocity = 0.8,
    callBack,
    width = double.infinity,
    mController
  }){
    return InkWell(
      onTap: callBack,
      child: Container(
        height: 50.0,
        width: width,
        decoration: BoxDecoration(
          color: mColor.withOpacity(shouldOpocity),
          borderRadius: const BorderRadius.all(
              Radius.circular(10)
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15.0,),
            Center(
              child: Icon(
                mIcon,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                mTitleText,
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 17.0
                ),
              ),
            ),
            Container(
              width: 200.0,
                child: TextField(
                  controller: mController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.roboto(color: Colors.white),
                      hintText: mTitle,
                      ),
                )
            )
          ],
        ),
      ),
    );
  }

  static Widget passwordTextField(TextEditingController mController,{
    passwordVisible = false,
    callback = VoidCallback,
    label = 'Password',
    shouldOpocity = 0.8,
    mColor = CommonVar.BLACK_TEXT_FIELD_COLOR,
    enterTextColor = Colors.white
  }){
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: mColor.withOpacity(shouldOpocity),
        borderRadius: const BorderRadius.all(
            Radius.circular(10)
        ),
      ),
      child: TextFormField(
        style: GoogleFonts.roboto(
            color: enterTextColor
        ),
        keyboardType: TextInputType.text,
        controller: mController,
        obscureText: !passwordVisible,
        //This will obscure text dynamically
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintStyle: GoogleFonts.roboto(color: Colors.white),
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: callback,
          ),
        ),
      ),
    );
  }

  static Widget commonHeader(BuildContext context,String title){
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Row(
        children: [
          const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 10.0,),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.roboto(
                fontSize: 25.0,
                fontWeight: FontWeight.w800,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}