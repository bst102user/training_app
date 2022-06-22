import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_app/providers/basic_provider.dart';

class BasicStls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Consumer<BasicProvider>(builder: (context, providerVal, child){
              int temp = providerVal.temp;
              return Text('$temp');
            }),
            Consumer<BasicProvider>(builder: (context, providerValue, child){
              return MaterialButton(onPressed: (){
                providerValue.updateValue(100);
              },
                child: const Text('press me'),
                color: Colors.red,);
            },)
          ],
        ),
      ),
    );
  }

}