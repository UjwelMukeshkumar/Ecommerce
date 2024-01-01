import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/model/orderdetails.dart';
import 'package:flutter_application_1/ecommercepage/webservice.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orderdetails extends StatefulWidget {
  Orderdetails({super.key});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  String? username;

  void initstate() {
    super.initState();
    _loadusername();
  }

  void _loadusername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
    log("isLoggedin =" + username.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Order Details",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: fetchOrderDetails(username.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  log(snapshot.data!.length.toString());
                  final order_details = snapshot.data![index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 0,
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                        trailing: Icon(
                          Icons.arrow_drop_down_rounded,
                        ),
                        textColor: Colors.black,
                        iconColor: Colors.red,
                        collapsedTextColor: Colors.black,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              DateFormat.yMMMEd().format(order_details.date)
                                  as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              order_details.paymentmethod.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              order_details.totalamount.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.lightBlueAccent),
                            ),
                          ],
                        ),
                        children: [
                          ListView.separated(
                            itemCount: order_details.products.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(25),
                            physics: BouncingScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 9),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      Webservice().imageurl +
                                                          order_details
                                                              .products[index]
                                                              .image),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  order_details.products[index]
                                                      .productname,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      order_details
                                                          .products[index].price
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .red.shade900),
                                                    ),
                                                    Text(
                                                      order_details
                                                          .products[index]
                                                          .quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .green.shade800,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<OrderModel>?> fetchOrderDetails(String username) async {
    try {
      log("username ==" + username.toString());
      final response = await http.post(
          Uri.parse("http:bootcamp.cyralearnings.com/get_orderdetails.php"),
          body: {'username': username.toString()});

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load Order details');
      }
    } catch (e) {
      log("order details ==" + e.toString());
    }
    return null;
  }
}
