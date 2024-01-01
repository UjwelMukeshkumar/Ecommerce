import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/home.dart';
import 'package:flutter_application_1/ecommercepage/loginpaaage.dart';
import 'package:flutter_application_1/ecommercepage/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLoggedIn;
  @override
  void initState() {
    super.initState();
    _checkSessin();
  }

  void _checkSessin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    print("isloggedin =" + isLoggedIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == true ? Home() : LOGIN(),
    );
  }
}
