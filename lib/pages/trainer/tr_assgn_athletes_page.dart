import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_animated/loader.dart';
import 'package:training_app/common/api_interface.dart';
import 'package:training_app/common/common_methods.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/models/trainer/tr_assign_athletes_model.dart';
import 'package:training_app/pages/trainer/athletes_detail.dart';

class TrAssgnAthletesPage extends StatefulWidget{
  TrAssgnAthletesPageState createState() => TrAssgnAthletesPageState();
}

class TrAssgnAthletesPageState extends State<TrAssgnAthletesPage>{

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
              CommonWidgets.commonHeader(context, 'list athletes'.toUpperCase()),
              CommonWidgets.mHeightSizeBox(height: 20.0),
              FutureBuilder(
                future: CommonMethods.getUserId(),
                builder: (context,snapshot){
                  if(snapshot.data == null){
                    return const Text('Loading');
                  }
                  else{
                    String userId = snapshot.data as String;
                    return FutureBuilder(
                      future: CommonMethods.getRequest(ApiInterface.LIST_ATHLETES+userId, context),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Center(child: LoadingBouncingLine(size: 20,));
                        }
                        else{
                          Response mRes = snapshot.data as Response;
                          TrAssignAthletesModel model = trAssignAthletesModelFromJson(mRes.data);
                          List<AssignDatum> datum = model.data;
                          return Container(
                            height: MediaQuery.of(context).size.height*0.8,
                            child: ListView.builder(
                              itemCount: datum.length,
                              itemBuilder: (context, index){
                                return InkWell(
                                  onTap: (){
                                    Get.to(AthletesDetail(datum[index]));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            datum[index].fname+' '+datum[index].lname,
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          const Icon(
                                            Icons.edit,
                                            size: 20.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0,),
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(datum[index].createdAt),
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