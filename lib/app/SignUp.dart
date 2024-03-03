  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:trial/app/LoginPage.dart';

  class SignUpPage extends StatefulWidget {
    @override
    State<SignUpPage> createState() => _SignUpScreenState();
  }

  class _SignUpScreenState extends State<SignUpPage> {
    bool isSignupScreen = false;

    final _nameController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    Future SignUPButton() async {
      if (_passwordController.text != _confirmPasswordController.text) {
        // AlertDialog(semanticLabel: "Password doesnot match");
         showDialog(context: context, 
  builder: (context){
     return const AlertDialog(
        title:Text('Incorrect Password'),
      );
  },
  );
        return;
      }

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).then((value) async {
          await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
          });

          print("Created New Account Successfully!!!");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }).onError((error, stackTrace) {
          print("Error ${error.toString()}");
        });
      } on FirebaseAuthException catch (e) {
        print("Error ${e.toString()}");
      }
    }

    @override
    void dispose() {
      _nameController.dispose();
      _confirmPasswordController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

    Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:[
          Positioned(
            top:0,
            child: Container(
              height:300,
              width: 400,
              decoration: BoxDecoration(
                // borderRadius: bord,
                image:DecorationImage(
                  image:AssetImage("assets/images/LoginBG.jpeg"),
                fit:BoxFit.fill
                 )
              ),
              child: Container(
                padding: EdgeInsets.only(top:110,left: 90),
                color: Color.fromRGBO(191,67,97,100).withOpacity(.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Text("Yummy Eats",
                   style: TextStyle(
                    fontFamily:'Font1',
                    color: Colors.white,
                    fontSize:25),
                    ),
                ],
                ),
              ),
            ),
          ),
      //  main container for Login and signUP
          Positioned(
            top: 225,
            child: Container(
              height:380,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width-40,
              margin: EdgeInsets.symmetric(horizontal:20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                  color:Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5
                  )

                ]
              ),
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // backgroundColor: Color.fromRGBO(217, 217, 217, 100),
                  children: [
                  GestureDetector(
                   onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage()));
                },
                    child: Column(
                      children: [
                      Text("Login",
                      style:TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(217,217,217,100),
                         ) ,
                      ),
                    
                    if(isSignupScreen)
                      Container(
                        margin: EdgeInsets.only(top:3),
                        height:2,
                        width: 55,
                        color: Colors.black,
                      )
                    ],
                    ),
                  ),
                   GestureDetector(
                    onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SignUpPage()));
                },
                  
                     child: Column(
                      children: [
                      Text("Sign Up",
                      style:TextStyle(
                          fontFamily: 'Font1',
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(191,67,97,100),
                        ) ,
                      ),
                      Container(
                        margin: EdgeInsets.only(top:3),
                        height:2,
                        width: 55,
                      color: Colors.black,
                      )
                     ],
                   ),
                   )
                ],
                ),
                Container(
                  margin: EdgeInsets.only(top:20),
                  child: Column(
                    children: [
                        buildTextField("Name", false, false, _nameController),
          buildTextField("Email", false, true, _emailController),
            buildTextField("Password", true, false, _passwordController),
          buildTextField("Confirm Password", true, false, _confirmPasswordController),
          ],
                  ),
                )
              ],
              ),
            ),
          ),
       Positioned(
        top:500,
        right: 0,
        left: 0,
        child: GestureDetector(
          onTap:SignUPButton,
          child: Center(
            child: Container(
              height:60,
              width: 160,
              decoration: BoxDecoration(
               
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(197, 99, 35, 35),
                     borderRadius: BorderRadius.all(Radius.circular(35)),
                    boxShadow: [
                      BoxShadow(
                        color :Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0,1)
                      )
                    ]
                ),
                child: Center(
                  child: Text("SignUp",
                  style: TextStyle(
                      fontFamily: 'Font1',
                    fontSize: 23, fontWeight: FontWeight.bold,color: Colors.white,)
                    ),
                ),
              ),
              ),
          ),
        ),
          )
        ],
      ),
  );
}
    Widget buildTextField(String hintText, bool isPassword, bool isEmail, TextEditingController _controller) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextField(
          controller: _controller,
          obscureText: isPassword,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(35)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(35)),
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, fontFamily: 'Font1', color: Color.fromRGBO(217, 217, 217, 100)),
          ),
        ),
      );
    }
  }
