import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trial/app/apnadhabaMenu.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.restaurantName}) : super(key: key);
    final String restaurantName;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
        String restaurantName = widget.restaurantName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      backgroundColor: Color.fromRGBO(197, 67, 82, 88),
      // ignore: prefer_const_constructors
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.uniqueItems.length,
            itemBuilder: (context, index) {
              final item = cart.uniqueItems[index];
              final quantity = cart.getQuantity(item);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // Assuming you have an 'imagePath' property in your MenuItem class
                    Image.asset(
                      item.localImagePath,
                      width: 80, // Adjust the width as needed
                      height: 80, // Adjust the height as needed
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(fontFamily: 'Font1', fontSize: 20),
                          ),
                          Text(
                              'Quantity: $quantity - Price: ${item.price * quantity}',
                              style:
                                  TextStyle(fontFamily: 'Font1', fontSize: 20)),
                          // Add more details if needed
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total Price: ${Provider.of<CartProvider>(context).calculateTotalPrice()}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Save order to Firestore
          await saveOrderToFirestore(
              context, Provider.of<CartProvider>(context, listen: false),restaurantName);
          // Clear the cart after saving the order
          Provider.of<CartProvider>(context, listen: false).clearCart();
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> saveOrderToFirestore(BuildContext context, CartProvider cartProvider,String restaurantName) async {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    // Handle the case where the user is not authenticated
    return;
  }

  // Build a map representing the order
  Map<String, dynamic> orderData = {
    'userid': userId,
    'restaurantName': restaurantName,
    'items': {},
    'totalPrice': cartProvider.calculateTotalPrice(),
    'timestamp': FieldValue.serverTimestamp(),
  };

  // Group items by their name and store quantity and price
  cartProvider.uniqueItems.forEach((item) {
    final itemName = item.name;
    final quantity = cartProvider.getQuantity(item);
    final price = item.price;

    // Check if the item already exists in the order
    if (orderData['items'][itemName] == null) {
      orderData['items'][itemName] = {'quantity': quantity, 'price': price};
    } else {
      // If the item exists, update the quantity
      orderData['items'][itemName]['quantity'] += quantity;
    }
  });

  // Add the order to the 'orders' collection
  await orders.add(orderData);

  // Clear the cart after saving the order
  cartProvider.clearCart();
}
}
