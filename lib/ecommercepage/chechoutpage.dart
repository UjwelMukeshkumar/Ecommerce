import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/ecommercepage/home.dart';

import 'package:flutter_application_1/ecommercepage/model/usermodel.dart';
import 'package:flutter_application_1/ecommercepage/provider/cartprovider.dart';
import 'package:flutter_application_1/ecommercepage/webservice.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Checkout extends StatefulWidget {
  List<CartProduct> cart;
  Checkout({required this.cart});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int selectedValue = 1;

  void initstate() {
    super.initState();
    _loadusername();
  }

  String? username;

  void _loadusername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
    log("isLoggedin =" + username.toString());
  }

  orderPlace(
    List<CartProduct> cart,
    String amount,
    String payementmethod,
    String date,
    String name,
    String address,
    String phone,
  ) async {
    try {
      String jsondata = jsonEncode(cart);
      log('jsondata =${jsondata}');

      final vm = Provider.of<CartProvider>(context, listen: false);

      final response =
          await http.post(Uri.parse(Webservice().mainurl + "order.php"), body: {
        "username": username,
        "amount": amount,
        "paymentmethod": payementmethod,
        "date": date,
        "quantity": vm.count.toString(),
        "cart": jsondata,
        "name": name,
        "address": address,
        "phone": phone,
      });
      if (response.statusCode == 200) {
        log(response.body);
        if (response.body.contains("Sucess")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              content: Text(
                "YOUR ORDER SCUESSFULLY COMPLETD",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              )));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? Name, address, phone;
  String? payementmethod = "Cash on delivery";

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        title: const Text(
          "Checkout ",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<Usermodel?>(
                future: fetchUser(username.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Name = snapshot.data!.name;
                    phone = snapshot.data!.phone;
                    address = snapshot.data!.address;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Name :",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(Name.toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "phone :",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(phone.toString())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text("address :",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    address.toString(),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          SizedBox(
            height: 10,
          ),
          RadioListTile(
            value: 1,
            groupValue: selectedValue,
            onChanged: (int? value) {
              setState(() {
                selectedValue = value!;
                payementmethod = 'cash on delivery';
              });
            },
            title: Text(
              'Cash on delivery',
              style: TextStyle(fontFamily: "muli"),
            ),
            subtitle: Text(
              'Pay cash at home',
              style: TextStyle(fontFamily: "mmuli"),
            ),
          ),
          RadioListTile(
            value: 1,
            groupValue: selectedValue,
            onChanged: (int? value) {
              setState(() {
                selectedValue = value!;
                payementmethod = 'online';
              });
            },
            title: Text("Pay Now"),
            subtitle: Text(
              "Online Payment",
            ),
          ),
        ],
      )),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            String datetime = DateTime.now().toString();

            log(datetime.toString());
            orderPlace(widget.cart, vm.totalPrice.toString(), payementmethod!,
                datetime, Name!, address!, phone!);
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.green),
            child: Container(
              child: Text(
                "checkout",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Usermodel?> fetchUser(String username) async {
    try {
      final response = await http.post(
          Uri.parse("http://bootcamp.cyralearnings.com/get_user.php"),
          body: {'username': username});

      if (response.statusCode == 200) {
        return Usermodel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load user");
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
