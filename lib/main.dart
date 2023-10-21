import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_services/splash_services.dart';
import 'package:untitled1/ui/auth/verify_code.dart';
import 'package:untitled1/ui/forget_password.dart';
import 'package:untitled1/ui/splash_screen.dart';
import 'package:untitled1/ui/upload_image.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(),

    );
  }
}







