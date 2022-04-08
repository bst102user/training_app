import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/all_trainers_model.dart';

class SelectTrainer extends StatefulWidget{
  SelectTrainerState createState() => SelectTrainerState();
}

class SelectTrainerState extends State<SelectTrainer>{
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
              CommonWidgets.commonHeader(context, 'select trainer'.toUpperCase()),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              FutureBuilder(
                future: CommonMethods.getRequest(ApiInterface.ALL_TRAINER, context),
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return Center(child: LoadingBouncingLine(size: 20,));
                  }
                  else{
                    Response mRes = snapshot.data as Response;
                    AllTrainersModel allTrainerModel =  allTrainersModelFromJson(mRes.data);
                    List<AlTrainerDatum> datum = allTrainerModel.data;
                    return Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: ListView.builder(
                        itemCount: datum.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              Navigator.pop(context, datum[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  datum[index].fname+' '+datum[index].lname,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                const Divider(
                                  color: Colors.white,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}