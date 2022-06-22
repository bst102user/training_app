import 'package:flutter/material.dart';
import 'package:training_app/providers/provider2/user_model.dart';
import 'package:http/http.dart' as http;

class BoolProvider extends ChangeNotifier{
  bool mBool = false;
  updateValue(){
    mBool=!mBool;
    notifyListeners();
  }

  List<UserModel> userList = [];


  Future<List<UserModel>> getAllUser()async{
    var myDataRes = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    List<UserModel> userModel = userModelFromJson(myDataRes.body);
    return userModel;
  }

  getActualData() async{
    this.userList = await getAllUser();
    notifyListeners();
  }

}