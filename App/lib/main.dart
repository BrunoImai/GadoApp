
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gado_app/user/InitialView.dart';
import 'package:gado_app/user/registerView.dart';

import 'home/homePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InitialView(),
  ));
}