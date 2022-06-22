import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:training_app/firebase/screens/home_screen.dart';
import 'package:training_app/pages/trainer/notification_trainer.dart';
import 'package:training_app/pages/trainer/tr_assgn_athletes_page.dart';
import 'package:training_app/providers/basic_provider.dart';
import 'package:training_app/providers/basic_stls.dart';
import 'package:training_app/providers/provider2/api_page.dart';
import 'package:training_app/providers/provider2/bool_page.dart';
import 'package:training_app/providers/provider2/bool_provider.dart';
import 'package:training_app/splash_screen.dart';

const apiKey = "AIzaSyAgseBhE7uD3XlhDWF2oh7W5xYuYU1ZjqY";

const projectId = "trainingapp-f2ce0";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // configLocalNotification();
  // registerNotification();
  // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: UserValues()),
        // ChangeNotifierProvider.value(value: Counter()),
        ChangeNotifierProvider.value(value: BasicProvider()),
        ChangeNotifierProvider.value(value: BoolProvider())
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/traiisgnathlete':(BuildContext context) => TrAssgnAthletesPage(),
          '/homepage' : (BuildContext context) => HomeScreen(),
          '/notificationtrainer' : (BuildContext context) => NotificationTrainer(),
        },
        // home: TimeSeriesLineAnnotationChart(_createSampleData())
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firedart/firedart.dart' hide FirebaseAuth;
// import 'package:firedart/firestore/firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:training_app/firebase/screens/home_screen.dart';
// import 'package:training_app/pages/trainer/notification_trainer.dart';
// import 'package:training_app/pages/trainer/tr_assgn_athletes_page.dart';
// import 'package:training_app/splash_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firestore_ref/firestore_ref.dart';
//
//
// const apiKey = "AIzaSyAgseBhE7uD3XlhDWF2oh7W5xYuYU1ZjqY";
// const projectId = "trainingapp-f2ce0";
// const messagingSenderId = "97950287171";
// const appId = "1:97950287171:ios:8a36b7b689b1994b48dbf6";
// const authDomain = "trainingapp-f2ce0.firebaseapp.com";
// const databaseURL = "https://trainingapp-f2ce0-default-rtdb.firebaseio.com";
// const storageBucket = "trainingapp-f2ce0.appspot.com";
// const measurementId = "G-JF8531K30D";
//
// void main() async{
//   const isEmulator = bool.fromEnvironment('IS_EMULATOR');
//
//   firestoreOperationCounter.enabled = true;
//
//   Firestore.initialize(projectId);
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: apiKey,
//         appId: appId,
//         messagingSenderId: messagingSenderId,
//         projectId: projectId,
//         authDomain: authDomain,
//         databaseURL: databaseURL,
//         storageBucket: storageBucket,
//         measurementId: measurementId,
//       )
//   );
//
//   if (isEmulator) {
//     const localhost = 'localhost';
//     FirebaseFunctions.instance.useFunctionsEmulator(localhost, 5001);
//     FirebaseFirestore.instance.useFirestoreEmulator(localhost, 8080);
//     await Future.wait(
//       [
//         FirebaseAuth.instance.useAuthEmulator(localhost, 9099),
//         FirebaseStorage.instance.useStorageEmulator(localhost, 9199),
//         FirebaseStorage.instance.useStorageEmulator('localhost', 9199)
//       ],
//     );
//   } else if (true) {
//     // Firestore.instance.settings(persistenceEnabled: false)
//     FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
//   }
//   // await _connectToFirebaseEmulator();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: SplashScreen(),
//         routes: <String, WidgetBuilder>{
//           '/traiisgnathlete':(BuildContext context) => TrAssgnAthletesPage(),
//           '/homepage' : (BuildContext context) => HomeScreen(),
//           '/notificationtrainer' : (BuildContext context) => NotificationTrainer(),
//         },
//       // home: TimeSeriesLineAnnotationChart(_createSampleData())
//     );
//   }
// }
//
