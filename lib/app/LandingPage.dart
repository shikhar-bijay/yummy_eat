import 'package:flutter/material.dart';
import 'package:trial/app/ServicePage.dart';
// import 'package:mini_project/app/ServicePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPage1State createState() => _LandingPage1State();
}

class _LandingPage1State extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text('Yummy Eats'),
        ),
        backgroundColor: Color.fromRGBO(197, 67, 82, 88),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Builder(builder: (context) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ServicePage(),
                        ));
                      },
                      child: Center(
                          child: Container(
                              width: 400,
                              height: 400,
                              child: Image.asset(
                                  'assets/images/yummy-eats1.jpg'))));
                }),
                // ignore: prefer_const_constructors
                Center(
                  // ignore: prefer_const_constructors
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'Yummy Eats Enjoy at Your Seats',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Font1',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
