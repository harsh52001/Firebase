import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/auth/login_screen.dart';
import 'package:untitled1/ui/firestore/firestore_list_screem.dart';
import 'package:untitled1/ui/posts/post_screen.dart';
import 'package:untitled1/ui/upload_image.dart';

class SplashServices
{

  void isLogin(BuildContext context)
  {
    final FirebaseAuth auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null) {
      Timer(const Duration(seconds: 1),
              () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostScreen())));
    }//postScrreen  //FirestoreScreen  //UploadImageScreen
    else
      {
        Timer(const Duration(seconds: 1),() =>
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginScreen()))
        );
      }


  }

}