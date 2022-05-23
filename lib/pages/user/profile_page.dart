import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/methods.dart';
import 'package:training_app/models/profile_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';

class ProfilePage extends StatefulWidget{
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  String dateStr = '';
  DateTime selectedDate = DateTime.now();
  String birthDate = 'Birthday';
  bool isDataShown = true;
  List<ProfileDatum>? listData;
  String phoneCode = '+1';
  String profilePictureName = '';

  File? imageFile;
  String? base64Image;

  Future<String> getImageUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String imgUrl = preferences.getString("profile_fullpath").toString();
    print(imgUrl);
    return imgUrl;
  }

  void uploadImage1(File _image) async {

    // open a byteStream
    var stream = http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    String userId = await CommonMethods.getUserId();
    var uri = Uri.parse("https://teamwebdevelopers.com/sportsfood/api/profile_file/"+userId);

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = http.MultipartFile('sendimage', stream, length);

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

    }).catchError((e) {
      print(e);
    });
  }

  Future<dynamic> getProfileData()async{
    // CommonMethods.showAlertDialog(context);
    Dio dio = Dio();
    dio.options.connectTimeout = 50000;
    dio.options.receiveTimeout = 30000;
    dio.options.sendTimeout = 30000;
    // String userId = CommonMethods.getStrPref('user_id').toString();
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String str = mPref.getString('user_id').toString();
    try {
      var response = await Dio().get(ApiInterface.GET_PROFILE+str);
      print(response);
      // Get.back();
      setState(() {
        ProfileModel profileModel = profileModelFromJson(response.toString());
        listData = profileModel.data;
        nameController.text = listData![0].fname;
        lastnameController.text = listData![0].lname;
        emailController.text = listData![0].email;
        mobileController.text = listData![0].phone;
        birthDate = DateFormat('yyyy-MM-dd').format(listData![0].dob);
        profilePictureName = listData![0].profileImage;
        mPref.setString("profile_fullpath",profilePictureName);
      });
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  initState(){
    super.initState();
    getProfileData();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      if(this.mounted){
        setState(() {
          selectedDate = selected;
          print(selectedDate);
          birthDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        });
      }
  }

  updateProfile()async{

  }

  showCountryCode(){
    showCountryPicker(
      context: this.context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          phoneCode = "+"+country.phoneCode;
        });
      },
    );
  }

  Future<void>_showChoiceDialog(BuildContext context) {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      rotate: 0,
    );
    print(file.lengthSync());
    return result!;
  }

  void _openGallery(BuildContext context) async{
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    final dir = await path_provider.getTemporaryDirectory();
    final tempTargetPath = dir.absolute.path + "/temp.jpg";
    File compressFile = await testCompressAndGetFile(imageFile!, tempTargetPath);
    String userId = await CommonMethods.getUserId();
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(ApiInterface.UPLOAD_PROFILE_PICTURE+userId));
    var pic = await http.MultipartFile.fromPath("sendimage", compressFile.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    getProfileData();
    setState(() {

    });
  }

  void _openCamera(BuildContext context)  async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );
    Navigator.pop(context);
    CommonMethods.showAlertDialog(context);
    imageFile = File(pickedFile!.path);
    final dir = await path_provider.getTemporaryDirectory();
    final tempTargetPath = dir.absolute.path + "/temp.jpg";
    File compressFile = await testCompressAndGetFile(imageFile!, tempTargetPath);
    // final dir = await path_provider.getTemporaryDirectory();
    String userId = await CommonMethods.getUserId();
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(ApiInterface.UPLOAD_PROFILE_PICTURE+userId));
    var pic = await http.MultipartFile.fromPath("sendimage", compressFile.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    Get.back();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    getProfileData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: CommonMethods.deviceHeight(context),
        width: CommonMethods.deviceWidth(context),
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/profile.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
          child: Column(
            children: [
              CommonWidgets.commonHeader(context, 'profile'),
              InkWell(
                onTap: (){
                  _showChoiceDialog(context);
                },
                child: imageFile==null?FutureBuilder(
                  future: getImageUrl(),
                  builder: (context, snapshot){
                    if(snapshot.data == null){
                      return const CircleAvatar(
                        radius: 50.0,
                        foregroundImage:
                        NetworkImage(
                          'https://via.placeholder.com/150',
                        ),
                        backgroundColor: Colors.transparent,
                      );
                    }
                    else{
                      String imagePath = snapshot.data as String;
                      if(imagePath.length<5){
                        return const CircleAvatar(
                          radius: 50.0,
                          foregroundImage:
                          NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }
                      else if(imagePath.substring(imagePath.length - 5) == '.jpeg'
                          ||imagePath.substring(imagePath.length - 4) == '.png'
                          ||imagePath.substring(imagePath.length - 4)=='.jpg') {
                        return CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                          NetworkImage(ApiInterface.PROFILE_IMAGE_PATH+(snapshot.data as String)),
                          backgroundColor: Colors.transparent,
                        );
                      }
                      else{
                        return const CircleAvatar(
                          radius: 30.0,
                          foregroundImage:
                          NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }
                    }
                  },
                ):CircleAvatar(
                  radius: 50.0,
                  backgroundImage: FileImage(imageFile!),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.7,
                child: ListView(
                  children: [
                    CommonWidgets.mHeightSizeBox(height: 25.0),
                    CommonWidgets.commonTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.person,
                        mTitle: 'Name',
                        keybordType: TextInputType.text,
                        mController: nameController
                    ),
                    CommonWidgets.mHeightSizeBox(),
                    CommonWidgets.commonTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.person,
                        mTitle: 'Last Name',
                        keybordType: TextInputType.text,
                        mController: lastnameController
                    ),
                    CommonWidgets.mHeightSizeBox(),
                    CommonWidgets.commonTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.email,
                        mTitle: 'Email',
                        keybordType: TextInputType.emailAddress,
                        mController: emailController
                    ),
                    CommonWidgets.mHeightSizeBox(),
                    CommonWidgets.commonTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.phone,
                        mTitle: 'Mobile Number',
                        keybordType: TextInputType.number,
                        mController: mobileController
                    ),
                    CommonWidgets.mHeightSizeBox(),
                    CommonWidgets.containerLikeTextField(
                        mColor: CommonVar.BLACK_TEXT_FIELD_COLOR2,
                        mIcon: Icons.date_range,
                        mTitle: birthDate,
                        callBack: (){
                          _selectDate(context);
                        }
                    ),
                    CommonWidgets.mHeightSizeBox(height: 20.0),
                    CommonWidgets.mHeightSizeBox(height: 20.0),
                    CommonWidgets.commonButton('SAVE',()async{
                      if(emailController.text.isEmpty
                          ||nameController.text.isEmpty
                          ||mobileController.text.isEmpty||birthDate=='Birthday'){
                        CommonMethods.showToast(context, 'All Fields Mandatory');
                      }
                      else if(!CommonMethods.isEmailValid(emailController.text)){
                        CommonMethods.showToast(context, 'Pleas enter valid email');
                      }
                      // else if(!CommonMethods.validateMobile(mobileController.text)){
                      //   CommonMethods.showToast(context, 'Pleas enter valid mobile');
                      // }
                      else {
                        CommonMethods.showAlertDialog(context);
                        SharedPreferences mPref = await SharedPreferences
                            .getInstance();
                        String userId = mPref.getString('user_id').toString();
                        Map mMap = {
                          "fname": nameController.text,
                          "lname": lastnameController.text,
                          "email": emailController.text,
                          "phone": mobileController.text,
                          "dob": birthDate
                        };
                        CommonMethods.commonPutApiData(
                            ApiInterface.UPDATE_PROFILE + userId, mMap).then((
                            response) {
                          print(response.toString());
                          // updateUser(nameController.text,emailController.text);
                          update(emailController.text, nameController.text, lastnameController.text);
                          Map mMap = json.decode(response.toString());
                          String status = mMap['status'];
                          String message = mMap['message'];
                          if (status == 'success') {
                            Get.back();
                            CommonMethods.getDialoge(
                                'Profile updated', intTitle: 2, voidCallback: () {
                              Get.back();
                              Get.back();
                            });
                          }
                          else {
                            CommonMethods.getDialoge(message, intTitle: 1);
                          }
                        });
                      }
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