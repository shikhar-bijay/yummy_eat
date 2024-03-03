import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trial/app/CartPage.dart';
import 'package:trial/app/Favourites.dart';
import 'package:trial/app/ProfilePage.dart';
import 'package:trial/app/apnadhabaMenu.dart';
import 'package:trial/app/firebase_search_optn.dart';


class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({Key? key}) : super(key: key);

  @override
  _FoodDeliveryHomePageState createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  int _currind = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    _callAddRestaurantsData();
  }

  Future<void> _callAddRestaurantsData() async {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      updateSearchResults(query);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search Restaurants',
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 209, 4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 209, 4),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Popular Restaurants',
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
                // Displaying restaurants dynamically from Firestore
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Restaurants').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('No restaurants available.'),
                      );
                    }

                    List<QueryDocumentSnapshot> restaurants = snapshot.data!.docs;

                    return Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          var restaurant = restaurants[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>ApnaDhabaMenuPage(
                                  restaurantName: restaurant['name'],
                                  
                                )
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 236, 209, 4),
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        restaurant['image_url'],
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 150,
                                      left: 8,
                                      child: Center(
                                        child: Text(
                                          restaurant['name'],
                                          style: TextStyle(
                                            fontFamily: 'Font1',
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
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
                
                // ... rest of your existing code
                Text(
                  'Popular Cuisines',
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                      fontFamily: 'Font1', fontSize: 40, color: Colors.white),
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                               child: Image.asset(
                            'assets/images/momos.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                               child: Image.asset(
                            'assets/images/pizza.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                               child: Image.asset(
                            'assets/images/noodle.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                               child: Image.asset(
                            'assets/images/donut.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            color: Colors.black,
                            // ignore: prefer_const_constructors
                            borderRadius: BorderRadius.only(
                                // ignore: prefer_const_constructors
                                topLeft: Radius.circular(20),
                                // ignore: prefer_const_constructors
                                topRight: Radius.circular(20))),
                        child: ClipRRect(
                          // ignore: prefer_const_constructors
                          borderRadius: BorderRadius.only(
                              // ignore: prefer_const_constructors
                              topLeft: Radius.circular(20),
                              // ignore: prefer_const_constructors
                              topRight: Radius.circular(20)),
                          child: Image.asset(
                            'assets/images/apna_dhaba.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                        top: 210,
                        left: 15,
                        // ignore: prefer_const_constructors
                        child: Text(
                          'Apna Dhaba',
                          // ignore: prefer_const_constructors
                          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                        top: 210,
                        left: 135,
                        // ignore: prefer_const_constructors
                        child: Text(
                          'North Indian',
                          // ignore: prefer_const_constructors
                          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                          top: 215,
                          left: 265,
                          // ignore: prefer_const_constructors
                          child: Icon(
                            Icons.access_time,
                            size: 20,
                          )),
                      // ignore: prefer_const_constructors
                      Positioned(
                          top: 210,
                          left: 295,
                          // ignore: prefer_const_constructors
                          child: Text(
                            '20-25 min',
                            style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                          )),
                    ],
                  ),
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            color: Colors.black,
                            // ignore: prefer_const_constructors
                            borderRadius: BorderRadius.only(
                              // ignore: prefer_const_constructors
                              topLeft: Radius.circular(20),
                              // ignore: prefer_const_constructors
                              topRight: Radius.circular(20),
                            )),
                        child: ClipRRect(
                          // ignore: prefer_const_constructors
                          borderRadius: BorderRadius.only(
                              // ignore: prefer_const_constructors
                              topLeft: Radius.circular(20),
                              // ignore: prefer_const_constructors
                              topRight: Radius.circular(20)),
                          child: Image.asset(
                            'assets/images/mini_punjab.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                        top: 210,
                        left: 15,
                        // ignore: prefer_const_constructors
                        child: Text(
                          'Mini Punjab',
                          // ignore: prefer_const_constructors
                          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                        top: 210,
                        left: 135,
                        // ignore: prefer_const_constructors
                        child: Text(
                          'North Indian',
                          // ignore: prefer_const_constructors
                          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                          top: 215,
                          left: 265,
                          // ignore: prefer_const_constructors
                          child: Icon(
                            Icons.access_time,
                            size: 20,
                          )),
                      // ignore: prefer_const_constructors
                      Positioned(
                          top: 210,
                          left: 295,
                          // ignore: prefer_const_constructors
                          child: Text(
                            '30-35 min',
                            // ignore: prefer_const_constructors
                            style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                          ))
                    ],
                  ),
                ),
                // ignore: sized_box_for_whitespace
          
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          if (searchResults.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchResults[index]['name']),
                            leading: Image.network(
                              searchResults[index]['image_url'],
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'Add ',
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
                        builder: (context) => FoodDeliveryHomePage()));
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AddRestaurantPage()),
              );
              break;
            // case 2:
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => CartPage()),
            //   );
            //   break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }

  void updateSearchResults(String query) async {
    List<Map<String, dynamic>> results = await FirestoreService.searchRestaurants(query);

    setState(() {
      searchResults = results;
    });
  }
}

class FirestoreService {
  static Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    // Implement your search logic here, query Firestore or any other method
    // Return a List<Map<String, dynamic>> with restaurant details
    // This is a placeholder, you need to replace it with actual search logic
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) => doc.data()).toList();
      return results;
    } catch (e) {
      print('Error searching restaurants: $e');
      return [];
    }
  }


}


