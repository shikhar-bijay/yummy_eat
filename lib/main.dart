// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trial/app/apnadhabaMenu.dart';
import 'package:trial/app/authPage.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey:);
  runApp(
    ChangeNotifierProvider(create: (context)=> CartProvider(),
    child:MyApp(),
    ),
  );
    
}

class MyApp extends StatelessWidget{
  const MyApp({super.key} 
  
  );

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );

  }
}
