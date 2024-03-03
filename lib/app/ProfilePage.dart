// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:trial/app/LoginPage.dart';
import 'package:trial/app/Profiledetail.dart';
import 'package:trial/app/ServicePage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}):super(key:key);

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // int _currind = 3;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    // ignore: prefer_const_constructors
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context)=>ServicePage()
                                ),
                              );
          }, icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text('Profile',style: TextStyle(fontFamily: 'Font1', fontSize: 20),),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(isDark?LineAwesomeIcons.sun :LineAwesomeIcons.moon))
          ],
        ),
      body:SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: 120,height: 120,
                  child: ClipRRect(
                    borderRadius:BorderRadius.circular(100),
                    child:const Image(image:AssetImage('assets/images/profileSample.jpg'))),
                ),
                const SizedBox(height: 10),
                Text(user.email!,style: TextStyle(fontFamily: 'Font1', fontSize: 30),),
                Text('User emailId',style: TextStyle(fontFamily: 'Font1', fontSize: 20),),
                const SizedBox(height:20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: (){
                       Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>ProfiledetailPage()
                                ),
                              );
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(197, 67, 82, 88),side: BorderSide.none,shape: const StadiumBorder()
                  ),
                  child: const Text('Edit Profile',style: TextStyle(fontFamily: 'Font1', color:Colors.yellow),),

                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                // MENU

                ProfileMenuwidget(title: 'Your Order',icon: LineAwesomeIcons.wallet,endIcon: false,onPress: (){}),
                ProfileMenuwidget(title: 'LogOut',icon: LineAwesomeIcons.alternate_sign_out,endIcon: false,onPress: (){  FirebaseAuth.instance.signOut();             
     Navigator.of(context).pushAndRemoveUntil(                 
     MaterialPageRoute(builder:(context) => LoginPage()),(route)=>false,
     );
}),

               ] ,
              
              ),
          ),
      ),
        );
  }
}

class ProfileMenuwidget extends StatelessWidget {
  const ProfileMenuwidget({
   Key?key,
   required this.title,
   required this.icon,
   required this.onPress,
   this.endIcon=true,
  }) : super(key: key);

  final String title ;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;


  @override
  Widget build(BuildContext context) {
        var isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
        var iconColor =isDark? Colors.yellow :Color.fromRGBO(197, 67, 82, 88);

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor!.withOpacity(.1),
        ),
        child:  Icon(icon,color:iconColor),
      ),
      title : Text(title, style: TextStyle(fontFamily: 'Font1', fontSize: 20),),
      trailing:endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(.1),
        ),
        child: const Icon(LineAwesomeIcons.angle_right,color:Color.fromRGBO(197, 67, 82, 88),)):null,
    );
  }
}
