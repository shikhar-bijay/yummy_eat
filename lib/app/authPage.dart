
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trial/app/LandingPage.dart';
import 'package:trial/app/LoginPage.dart';


class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
builder: (context,snapshot){
  if(snapshot.hasData){
    return LandingPage();
  }
  else{
    return LoginPage();
  }
},
 ),
 );
  }
}