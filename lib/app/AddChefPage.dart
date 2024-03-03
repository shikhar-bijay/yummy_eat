import 'dart:io';
// import 'dart:js_util';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trial/app/ChefBook.dart';
import 'package:trial/app/ProfilePage.dart';

class AddChefPage extends StatefulWidget {
  @override
  _AddChefPageState createState() => _AddChefPageState();
}

class _AddChefPageState extends State<AddChefPage> {
    int _currind = 0;
final TextEditingController _nameController = TextEditingController();
final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bookingAmountController = TextEditingController();  File? _image;

  Future<void> _uploadImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null && _image != null) {
      // 1. Upload image to Firebase Storage
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('chef_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageReference.putFile(_image!);

      // 2. Get the download URL of the uploaded image
      final String imageUrl = await storageReference.getDownloadURL();

      // 3. Save name and image URL in Firestore collection
      await FirebaseFirestore.instance.collection('Chefs').add({
    'name': _nameController.text,
      'image_url': imageUrl,
      'user_id': user.uid,
      'address': _addressController.text,
      'description': _descriptionController.text,
      'phone_no': _phonenoController.text,
      'booking_amount': _bookingAmountController.text,
      });

      // 4. Clear the text field and image selection
      _nameController.clear();
      setState(() {
        _image = null;
      });

      // 5. Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Chef added successfully!'),
        duration: Duration(seconds: 2),
      ));
    } else {
      // Handle user authentication or image selection errors
    }
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chef'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Chef Name'),
              ),
                  TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
                  TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
                  TextFormField(
                controller: _phonenoController,
                decoration: InputDecoration(labelText: 'phone no.'),
              ),
                  TextFormField(
                controller: _bookingAmountController,
                decoration: InputDecoration(labelText: 'Booking Amount'),
              ),
              
              SizedBox(height: 20),
              _image == null
                  ? ElevatedButton(
                      onPressed: _getImage,
                      child: Text('Select Image'),
                    )
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Add Chef'),
              ),
            ],
          ),
        ),
      ),
              bottomNavigationBar: BottomNavigationBar(
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            // ignore: prefer_const_constructors
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // ignore: prefer_const_constructors
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_sharp),
              label: 'Favorites',
            ),
            // ignore: prefer_const_constructors
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.shopping_cart),
            //   label: 'Favorites',
            // ),
            // ignore: prefer_const_constructors
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
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => ChefBookHomePage()));
                break;
              case 1:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AddChefPage()));
              break;
              // case 2:
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => CartPage()));
                // break;
              case 3:
                Navigator.pushReplacement (context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
                break;
            }
          },
        )
    );
  }
}