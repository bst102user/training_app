import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_app/providers/provider2/bool_provider.dart';
import 'package:training_app/providers/provider2/user_model.dart';

class ApiPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Consumer<BoolProvider>(builder: (context, providerValue, child){
        providerValue.getActualData();
        return ListView.builder(
          itemCount: providerValue.userList.length,
          itemBuilder: (context, index){
            List<UserModel> userModel = providerValue.userList;
            return Text(userModel[index].email);
          },
        );
      },),
    );
  }

}