import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:trial/app/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfiledetailPage extends StatefulWidget {
  const ProfiledetailPage({Key? key}) : super(key: key);
  @override
  _ProfiledetailPageState createState() => _ProfiledetailPageState();
}
class _ProfiledetailPageState extends State<ProfiledetailPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late String userId;

  @override

   void initState() {
    super.initState();
    // Fetch the user's ID when the widget initializes
    userId = FirebaseAuth.instance.currentUser!.uid;
    // Fetch and display user details
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // If the document exists, populate the controllers with existing data
        Map<String, dynamic> userData = userSnapshot.data()!;
        fullNameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneNoController.text = userData['phoneNo'] ?? '';
        addressController.text = userData['address'] ?? '';
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> updateProfile() async {
    try {
      // Update the user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNo': phoneNoController.text,
        'address': addressController.text,
      });

      // Display a success message or navigate to a success screen if needed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Profile Updated'),
          content: Text('Your profile has been updated successfully.'),
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
    } catch (e) {
      print('Error updating profile: $e');
      // Display an error message if the update fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while updating your profile. Please try again.'),
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          'User Details',
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body:  SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(image: AssetImage('assets/images/profileSample.jpg')),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.amber[600],
                          ),
                          child: const Icon(
                            LineAwesomeIcons.camera,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Form(
                    child: Column(
                      children: [
                         TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        label: Text('Full Name'),
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                        const SizedBox(height: 20),
                       TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text('E-mail Id'),
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),

                        const SizedBox(height: 20),
                            TextFormField(
                      controller: phoneNoController,
                      decoration: const InputDecoration(
                        label: Text('Phone No.'),
                        prefixIcon: Icon(Icons.call),
                      ),
                    ),
                        const SizedBox(height: 20),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        label: Text('Address'),
                        prefixIcon: Icon(Icons.maps_home_work_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              // Call the updateProfile method here
                                 updateProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(197, 67, 82, 88),
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Edit Profile', style: TextStyle(fontFamily: 'Font1', color: Colors.yellow)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // If need to remove
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Joined ',
                                style: TextStyle(fontSize: 12),
                                children: [
                                  TextSpan(text: 'Date of joining', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.withOpacity(.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }
}
 Future<void> updateProfile(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Get the user document from Firestore
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Fetch the existing user data
        DocumentSnapshot userData = await userRef.get();

        // Prepare updated data
        Map<String, dynamic> updatedData = {
          'fullName': 'Updated Name', // Replace with the actual updated name
          'email': 'updated@example.com', // Replace with the actual updated email
          'phoneNo': '1234567890', // Replace with the actual updated phone number
          // Add other fields as needed
        };

        // Update the document with the new data
        await userRef.set(updatedData, SetOptions(merge: true));

        // Show a success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Successful'),
            content: Text('Profile updated successfully!'),
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
    } catch (e) {
      // Handle any errors that occur during the process
      print('Update failed: $e');
    }
  }
