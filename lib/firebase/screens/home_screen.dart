// import 'package:chat_app/Authenticate/Methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_app/common/common_var.dart';
import 'package:training_app/common/common_widgets.dart';
import 'package:training_app/firebase/screens/chat_room.dart';
// import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../methods.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
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
    SharedPreferences mPref = await SharedPreferences.getInstance();
    String emailStr = mPref.getString('user_email') as String;
    return emailStr;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: CommonVar.BLACK_BG_COLOR,

        body: isLoading
            ? Center(
          child: Container(
            height: size.height / 20,
            width: size.height / 20,
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: CommonWidgets.commonHeader(context, 'Messanger',isShowBack: false),
            ),
            // SizedBox(
            //   height: size.height / 20,
            // ),
            // Container(
            //   height: size.height / 14,
            //   width: size.width,
            //   alignment: Alignment.center,
            //   child: Container(
            //     height: size.height / 14,
            //     width: size.width / 1.15,
            //     child: TextField(
            //       controller: _search,
            //       decoration: InputDecoration(
            //         hintText: "Search",
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: size.height / 50,
            // ),
            // ElevatedButton(
            //   onPressed: onSearch,
            //   child: Text("Search"),
            // ),
            // SizedBox(
            //   height: size.height / 30,
            // ),
            // userMap != null
            //     ? ListTile(
            //   onTap: () {
            //     String roomId = chatRoomId(
            //         _auth.currentUser!.displayName!,
            //         userMap!['name']);
            //
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (_) => ChatRoom(
            //           chatRoomId: roomId,
            //           userMap: userMap!,
            //         ),
            //       ),
            //     );
            //   },
            //   leading: Icon(Icons.account_box, color: Colors.black),
            //   title: Text(
            //     userMap!['name'],
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 17,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   subtitle: Text(userMap!['email']),
            //   trailing: Icon(Icons.chat, color: Colors.black),
            // )
            //     : Container(),
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot){
                if(snapshot.data == null){
                  return Text('Loading...');
                }
                else{
                  List usersList = snapshot.data as List;
                  return Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, index){
                        return FutureBuilder(
                          future: getCurrentUser(),
                          builder: (context, snapshot){
                            if(snapshot.data == null){
                              return const Text('Loading');
                            }
                            else{
                              String emailStr = snapshot.data as String;
                              return (emailStr == usersList[index]['email'])?Container():Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        String roomId = chatRoomId(
                                            _auth.currentUser!.displayName!,
                                            usersList[index]['name']);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatRoom(
                                              chatRoomId: roomId,
                                              userMap: usersList[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CommonVar.RED_BUTTON_COLOR),
                                              child: Center(
                                                child: Text(usersList[index]['name'][0].toString().toUpperCase(),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w800
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usersList[index]['name'],
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Text(
                                                  usersList[index]['email'],
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.white,)
                                  ],
                                ),
                              );
                            }
                          },
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
    );
  }
}