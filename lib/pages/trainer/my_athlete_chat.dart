import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/firebase/screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<dynamic> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);

    return allData;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    hideNavigator();
  }

  hideNavigator()async {
    List usersList = await getData();
    List<String> prefVal = await getCurrentUser();
    for(int index=0;index<usersList.length;index++){
      if(usersList[index]['user_type'] == 'trainer' && usersList[index]['trainer_id'] == prefVal[2]){
        String roomId = chatRoomId(
            _auth.currentUser!.email!,
            usersList[index]['email']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ChatRoom(chatRoomId: roomId, userMap: usersList[index])),
                (Route<dynamic> route) => false);
      }
    }

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
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
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

        body: Center(
          child: Text('Chat opening...',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 20.0
              ),),
        )
      ),
    );
  }
}