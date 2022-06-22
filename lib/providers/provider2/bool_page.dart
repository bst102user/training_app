import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_app/providers/provider2/bool_provider.dart';

class BoolPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<BoolProvider>(context, listen: false);
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Consumer<BoolProvider>(builder: (context, providerValue, child){
              return Text(providerValue.mBool?'Text1':'Text2');
            },),
            MaterialButton(onPressed: (){
              myProvider.updateValue();
            },
            child: const Text('Change'),
            color: Colors.red,),

          ],
        ),
      ),
    );
  }

}