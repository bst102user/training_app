import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/firebase/screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

import 'package:training_app/firebase/screens/chat_room_for_mac.dart';

class MyAthleteChat extends StatefulWidget{
  MyAthleteChatState createState() => MyAthleteChatState();
}

class MyAthleteChatState extends State<MyAthleteChat> with WidgetsBindingObserver{
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
  String? roomId;
  Map<String, dynamic>? userListMap;

  Future<dynamic> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String currentUserEmail = mPref.getString('user_email') as String;
    for(var userData in allData){
      if(currentUserEmail == userData['email']){
        mPref.getString('trainer_id') as String;
        mPref.setString('trainer_id', userData['trainer_id']);
      }
    }
    // if(currentUserEmail == all)

    print(allData);

    return allData;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    // hideNavigator();
  }

  Future<bool> hideNavigator()async {
    bool isEverythingOk = false;
    List usersList = await getData();
    List<String> prefVal = await getCurrentUser();
    for(int index=0;index<usersList.length;index++){
      if(usersList[index]['user_type'] == 'trainer' && usersList[index]['trainer_id'] == prefVal[2]){
        roomId = chatRoomId(
            _auth.currentUser!.uid,
            usersList[index]['uid']);
        userListMap = usersList[index];
        SharedPreferences mPref = await SharedPreferences.getInstance();
        mPref.setString('ch_fname', usersList[index]['name']);
        mPref.setString('ch_lname', usersList[index]['lname']);
        isEverythingOk = true;
        break;
      }
      else{
        isEverythingOk = false;
      }
    }
    return isEverythingOk;
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    int val1 = user1[0].toLowerCase().codeUnits[0];
    int val2 = user2.toLowerCase().codeUnits[0];
    if (val1 == val2) {
      val2 = val2+1;
    }
    if (val1 > val2) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  Future<dynamic> getCurrentUser()async{
    List<String> sharePrefValue = [];
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String emailStr = mPref.getString('user_email') as String;
    String userId = mPref.getString('user_id') as String;
    String trainerId = mPref.getString('trainer_id') as String;
    sharePrefValue.add(emailStr);
    sharePrefValue.add(userId);
    sharePrefValue.add(trainerId);
    return sharePrefValue;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: CommonVar.BLACK_BG_COLOR,
        body: FutureBuilder(
          future: hideNavigator(),
          builder: (context, snapshot){
            if(snapshot.data == null){
              return Center(
                child: Text('Chat opening...',
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20.0
                  ),),
              );
            }
            else{
              bool isEvrthngOk = snapshot.data as bool;
              if(isEvrthngOk){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Platform.isMacOS?ChatRoomForMac(chatRoomId: roomId!, userMap: userListMap!,isSetNavigation: true,):
                  ChatRoom(chatRoomId: roomId!, userMap: userListMap!,isSetNavigation: true,),
                );
              }
              else{
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/cycle_blur.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: ListView(
                      children: [
                        Text(
                          'Chat'.toUpperCase(),
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.8,
                          child: Center(
                            child: Text(
                              'No trainer available for you we will revert back once the trainer is available',
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18.0
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}