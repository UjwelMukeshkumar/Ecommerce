import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/ecommercepage/home.dart';
import 'package:flutter_application_1/ecommercepage/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Detailspage extends StatelessWidget {
  String name, price, image, description;
  int id;

  Detailspage({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });
  Future<bool> checkIfItemExitsInCart(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getString('cartItems');

    if (cartItems != null && cartItems.isNotEmpty) {
      List<dynamic> decodedCartItems = jsonDecode(cartItems);
      return decodedCartItems.any((item) => item['id'] == itemId);
    }
    return false;
  }

  Future<void> addItemToCart(
      intid, String name, double price, int quantity, String image) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemlist =
        jsonDecode(prefs.getString('cartItems') ?? '[]') as List<dynamic>;

    //check if item already exist in the cart.
    bool itemExists = cartItemlist.any((item) => item['id'] == id);
    if (!itemExists) {
      cartItemlist.add({
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
      });
      await prefs.setString('cartItems', jsonEncode(cartItemlist));
      print(
          'Added item to cart - ID: $id, Name: $name, Price: $price, Quantity: $quantity, Image: $image');
    } else {
      print('Item with Id: $id already exists in the cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("id =" + id.toString());
    print("name =" + name.toString());
    print("price =" + price.toString());
    print("desc =" + description.toString());
    print("image =" + image.toString());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: NetworkImage(image)),
                ),
                Positioned(
                    left: 15,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                    ))
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: (20)),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 246),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 2, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        name,
                        style: TextStyle(
                            color: Color.fromARGB(255, 61, 61, 139),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Rs.' + price,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            print("price ==" + double.parse(price).toString());

            var existingItemCart = context
                .read<CartProvider>()
                .getItems
                .firstWhere((element) => element.id == id);
            // ignore: unnecessary_null_comparison
            if (existingItemCart != null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: Text(
                    "The item all in the Cart",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )));
            } else {
              context
                  .read<CartProvider>()
                  .addItem(id, name, double.parse(price), 1, image);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: Text(
                    "Add item to Cart",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )));
            }
          },
          child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent),
              child: Center(
                  child: Text(
                "Add item to Cart",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ))),
        ),
      ),
    );
  }
}
