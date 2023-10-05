
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gado_app/user/InitialView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gado_app/userHome/homePage.dart';
import 'firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    routes: {
      '/user_home': (context) => UserHomePage(),
    },
    debugShowCheckedModeBanner: false,
    home: InitialView(),
  ));
}