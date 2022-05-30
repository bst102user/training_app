import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/trainer/tr_assign_athletes_model.dart';

class TrAssgnAthletesPage extends StatefulWidget{
  TrAssgnAthletesPageState createState() => TrAssgnAthletesPageState();
}

class TrAssgnAthletesPageState extends State<TrAssgnAthletesPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: [
          CommonWidgets.commonHeader(context, 'List Athletes'),
          FutureBuilder(
            future: CommonMethods.getRequest(ApiInterface.LIST_ATHLETES+'/8', context),
            builder: (context, snapshot){
              if(snapshot.data == null){
                return Text('Loading....');
              }
              else{
                Response mRes = snapshot.data as Response;
                TrAssignAthletesModel model = trAssignAthletesModelFromJson(mRes.data);
                List<AssignDatum> datum = model.data;
                return Text(datum[0].userType);
              }
            },
          )
        ],
      ),
    );
  }

}