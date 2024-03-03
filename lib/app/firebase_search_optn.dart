import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> addRestaurantsData() async {
    try {
      // Add restaurant 1 with image from URL
      await _addOrUpdateRestaurant(
        'Apna Dhaba',
        'gs://trial-245af.appspot.com/images/mini_punjab.jpg',
        ['Dish A', 'Dish B', 'Dish C'],
      );

      // Add restaurant 2 with image from URL
      await _addOrUpdateRestaurant(
        'Cake Shop',
        'gs://trial-245af.appspot.com/images/cake_shop.jpg',
        ['Dish X', 'Dish Y', 'Dish Z'],
      );

      print('Restaurants data added successfully!');
    } catch (e) {
      print('Error adding restaurants data: $e');
    }
  }

  static Future<void> _addOrUpdateRestaurant(
      String name, String imageUrl, List<String> dishes) async {
    try {
      // Check if the restaurant already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the restaurant already exists, you can choose to update it or skip
        print('$name already exists. Skipping...');
        return;
      }

      // If the restaurant doesn't exist, add it with a unique identifier
      await FirebaseFirestore.instance.collection('Restaurants').add({
        'name': name,
        'image_url': await _uploadImageFromUrl(imageUrl),
        'dishes': dishes,
      });

      print('Added restaurant: $name');
    } catch (e) {
      print('Error adding/updating restaurant: $e');
    }
  }

 static Future<String> _uploadImageFromUrl(String imageUrl) async {
    try {
      // Use the provided imageUrl directly
      return imageUrl;
    } catch (e) {
      print('Error uploading image from URL: $e');
      return ''; // Return an empty string or null if there's an error
    }
  }
  static Future<List<Map<String, dynamic>>> searchRestaurants(
      String query) async {
    try {
      List<Map<String, dynamic>> searchResults = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Restaurants')
          .where('name', isGreaterThanOrEqualTo: query)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        searchResults.add(data);
      }

      return searchResults;
    } catch (e) {
      print('Error searching restaurants: $e');
      return [];
    }
  }
}

 

  