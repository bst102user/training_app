import 'package:flutter/material.dart';

class TestSignInView extends StatefulWidget {
  @override
  _TestSignInViewState createState() => new _TestSignInViewState();
}


class _TestSignInViewState extends State<TestSignInView> {
  bool _load = false;
  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator =_load? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ):new Container();
    return new Scaffold(
        backgroundColor: Colors.white,
        body:  new Stack(children: <Widget>[new Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: new ListView(

            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                ,children: <Widget>[
                new TextField(),
                new TextField(),

                new FlatButton(color:Colors.blue,child: new Text('Sign In'),
                    onPressed: () {
                      setState((){
                        _load=true;
                      });

                      //Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new HomeTest()));
                    }
                ),

              ],),],
          ),),
          new Align(child: loadingIndicator,alignment: FractionalOffset.center,),

        ],));
  }

}