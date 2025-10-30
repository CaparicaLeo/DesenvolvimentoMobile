import 'package:auth_apk/firebase_options.dart';
import 'package:auth_apk/view/auth__page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: AuthPage(), debugShowCheckedModeBanner: false));
}
