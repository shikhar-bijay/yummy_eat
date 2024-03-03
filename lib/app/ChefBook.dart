import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trial/app/AddChefPage.dart';
import 'package:trial/app/ProfilePage.dart';
import 'package:trial/app/chefDetailPage.dart';
import 'package:trial/app/firebase_search_optn.dart';

class ChefBookHomePage extends StatefulWidget {
  const ChefBookHomePage({Key? key}) : super(key: key);

  @override
  _ChefBookHomePageState createState() => _ChefBookHomePageState();
}

class _ChefBookHomePageState extends State<ChefBookHomePage> {
  int _currind = 0;

  @override
  void initState() {
    super.initState();
    _callAddChefsData();
  }

  Future<void> _callAddChefsData() async {
    // Commenting this out as you already have restaurant data in Firestore
    // await FirestoreService.addRestaurantsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            style: TextStyle(fontFamily: 'Font1', fontSize: 40),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(191, 67, 82, 88),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Popular Chefs',
              style: TextStyle(
                fontFamily: 'Font1',
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 30,
            ),
            // Displaying chefs dynamically from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Chefs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No chefs available.'),
                  );
                }

                List<QueryDocumentSnapshot> chefs = snapshot.data!.docs;

                return Container(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: chefs.length,
                    itemBuilder: (context, index) {
                      var chef = chefs[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>ChefDetailsPage(chef:chef),),
                           );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color.fromARGB(255, 236, 209, 4),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    chef['image_url'],
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    chef['name'],
                                    style: TextStyle(
                                      fontFamily: 'Font1',
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'Add',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Favorites',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currind,
        onTap: (index) {
          setState(() {
            _currind = index;
          });
          // Handle navigation based on index
          switch (index) {
            case 0:
              // Do nothing or handle differently if needed
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => ChefBookHomePage()));
              break;
            case 1:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddChefPage()));
              break;
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ProfilePage()));
              break;
          }
        },
      ),
    );
  }
}

class FirestoreService {
  static Future<List<Map<String, dynamic>>> searchChefs(String query) async {
    // Implement your search logic here, query Firestore or any other method
    // Return a List<Map<String, dynamic>> with restaurant details
    // This is a placeholder, you need to replace it with actual search logic
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Chefs')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) => doc.data()).toList();
      return results;
    } catch (e) {
      print('Error searching chefs: $e');
      return [];
    }
  }
}
