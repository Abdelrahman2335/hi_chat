
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hi_chat/screen/auth.dart';
import 'package:hi_chat/screen/chat.dart';

void main() async {
  /// Important to know that we add this line because we are using async in the main function.
  WidgetsFlutterBinding.ensureInitialized();

  // if (!Platform.isAndroid && !Platform.isIOS && !Platform.isWindows) {
  //   await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyBRK8sFTf60JXgf7bZCuqfgZK0eaJJsHcQ",
  //         authDomain: "e-commerce-app-669f8.firebaseapp.com",
  //         projectId: "e-commerce-app-669f8",
  //         storageBucket: "e-commerce-app-669f8.appspot.com",
  //         messagingSenderId: "934406621606",
  //         appId: "1:934406621606:web:2e35911a1485cfd6e82767"),
  //     // name: "e-commerce-app-669f8",
  //   );
  //   log("First option");
  // } else {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //     name: "e-commerce-app-669f8",
  
  //   );
  //   log("Second opthin");
  // }
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBRK8sFTf60JXgf7bZCuqfgZK0eaJJsHcQ",
          authDomain: "e-commerce-app-669f8.firebaseapp.com",
          projectId: "e-commerce-app-669f8",
          storageBucket: "e-commerce-app-669f8.appspot.com",
          messagingSenderId: "934406621606",
          appId: "1:934406621606:web:2e35911a1485cfd6e82767"),
      // name: "e-commerce-app-669f8",
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder(

          /// this comes from firebase it helps you to know if the user is login or not,
          /// it's a stream so we need to use Stream to use it.
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            } else {
              return const AuthScreen();
            }
          })),
    );
  }
}
