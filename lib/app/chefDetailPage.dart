// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:trial/app/ChefBook.dart';


class ChefDetailsPage extends StatelessWidget {
  final Map<String, dynamic> chef;

  ChefDetailsPage({required this.chef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChefBookHomePage()),
            );
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          'Chef Details',
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Small image in the center
                    ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        chef['image_url'],
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Chef's name trailing the image
                    Text(
                      chef['name'],
                      style: TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Additional details below
                buildDetailRow('Phone Number', chef['phone_no'],false),
                SizedBox(height: 8),
                buildDetailRow('Address', chef['address'], true),
                SizedBox(height: 8),
                buildDetailRow('Description', chef['description'], true),
                SizedBox(height: 8),
                buildDetailRow('Booking Amount', chef['booking_amount'],false),
                SizedBox(height: 16),
                // Book button
                ElevatedButton(
                  onPressed: () {
                    // Handle booking action here
                    // You can navigate to a booking page or perform any other action
                      bookChef(context);
                  },
                  child: Text('Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, bool expand) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Use Expanded for flexible size based on content
          expand
              ? Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.fade,
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(fontSize: 18),
                ),
        ],
      ),
    );
  }


  void bookChef(BuildContext context) {
    String chefName = chef['name'];
    String chefId=chef['user_id'];
    String bookingAmount = chef['booking_amount'];
    String dateOfBooking = DateTime.now().toString(); // Current date and time

    // Replace with actual user details
    User? user =FirebaseAuth.instance.currentUser;
    // String userId=user.uid;
    if(user!=null){
      String userId =user.uid;
        String userEmail = 'john.doe@example.com';

    // Call FirestoreService method to book chef
    FirestoreService.bookChef(
      chefName: chefName,
      chefId:chefId,
      userId: userId,
      userEmail: userEmail,
      bookingAmount: bookingAmount,
      dateOfBooking: dateOfBooking,
    );
    }
  

    // Show a confirmation dialog or navigate to a success page if needed
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Successful'),
        content: Text('Chef booked successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class FirestoreService {
  static Future<void> bookChef({
    required String chefName,
     required String chefId,
    required String userId,
    required String userEmail,
    required String bookingAmount,
    required String dateOfBooking,
  })  async {
    CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');

    try {
      // Build a map representing the booking
User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not authenticated
        print('user not authenticated');
        return;
      }
       userEmail = user.email ?? 'guest@example.com';
      String  userId=user.uid;

      Map<String, dynamic> bookingData = {
        'chefName': chefName,
        'chefId':chefId,
         'userId': userId,
        'userEmail': userEmail,
        'bookingAmount': bookingAmount,
        'dateOfBooking': dateOfBooking,
      };

      // Add the booking to the 'bookings' collection
  await bookings.add(bookingData);
    // Show a success dialog
     print('Boking Successful');
    } catch (e) {
      // Handle any errors that occur during the process
    print('booking failed:$e');
    }
  }
}