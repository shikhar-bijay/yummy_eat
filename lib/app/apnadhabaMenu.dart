import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trial/app/CartPage.dart';

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String localImagePath;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.localImagePath,
  });
}

class CartProvider extends ChangeNotifier {
  List<MenuItem> _cartItems = [];

  List<MenuItem> get cartItems => _cartItems;

  void addItem(MenuItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  int getQuantity(MenuItem item) {
    return _cartItems.where((cartItem) => cartItem.name == item.name).length;
  }

  double calculateTotalPrice() {
    return _cartItems.fold(0, (total, item) => total + item.price);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  List<MenuItem> get uniqueItems {
    // Using a Set to ensure uniqueness
    Set<MenuItem> uniqueSet = Set.from(_cartItems);
    return uniqueSet.toList();
  }
}

class ApnaDhabaMenuPage extends StatelessWidget {
  final String rupeeSymbol = '₹';
final String restaurantName;  // Add more data as needed

  ApnaDhabaMenuPage({Key? key, required this.restaurantName}) : super(key: key);

  final List<MenuItem> menuItems = [
    MenuItem(
      name: 'chole bhature',
      description: 'delicious bhatura and spicy chola',
      price: 100.0,
      localImagePath: 'assets/images/punjabi_chole_bhature.jpg',
    ),
    MenuItem(
      name: 'Pizza',
      description: 'Classic pizza with your favorite toppings',
      price: 215.0,
      localImagePath: 'assets/images/pizza.jpg',
    ),
       MenuItem(
      name: 'Momos',
      description: 'Classic momos with your favorite toppings',
      price: 50.0,
      localImagePath: 'assets/images/momos.jpg',
    ),
      MenuItem(
      name: 'Donut',
      description: 'Donut with sweety taste',
      price: 55.0,
      localImagePath: 'assets/images/donut.jpg',
    ),
    // Add more items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
         backgroundColor: Color.fromRGBO(197, 67, 82, 88),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            menuItems[index].localImagePath,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              menuItems[index].name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              menuItems[index].description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '$rupeeSymbol${menuItems[index].price.toString()}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            _buildItemQuantity(context, menuItems[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              int totalQuantity = cart.cartItems.length;

              return ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage(restaurantName: restaurantName,)));
                },
                icon: Icon(Icons.shopping_cart),
                label: Text('View Cart ($rupeeSymbol$totalQuantity items)'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemQuantity(BuildContext context, MenuItem item) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              _decreaseItemQuantity(context, item);
            },
            child: Icon(
              Icons.remove,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Text(
            _getItemQuantity(context, item).toString(),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _increaseItemQuantity(context, item);
            },
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  int _getItemQuantity(BuildContext context, MenuItem item) {
    var cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.cartItems
        .where((cartItem) => cartItem.name == item.name)
        .length;
  }

  void _increaseItemQuantity(BuildContext context, MenuItem item) {
    Provider.of<CartProvider>(context, listen: false).addItem(item);
  }

  void _decreaseItemQuantity(BuildContext context, MenuItem item) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    //int currentQuantity = _getItemQuantity(context, item);

    // if (currentQuantity > 0) {
    //   // Find the first occurrence of the item in the cart and remove it

    // }
    cartProvider.removeItem(item);
  }
}
