import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/home.dart';
import 'package:flutter_application_1/ecommercepage/webservice.dart';

import 'package:flutter_application_1/singuppage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LOGIN extends StatefulWidget {
  const LOGIN({super.key});

  @override
  State<LOGIN> createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  final usernameController = TextEditingController();
  final passworController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print("isLoggedIn =" + isLoggedIn.toString());
    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.redAccent),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(30)),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 105, 240, 174),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 3),
                        blurRadius: 20.0,
                        offset: Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the UserName",
                          labelText: "Username",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: passworController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Password",
                            labelText: "Password",
                            prefixIcon: Icon(Icons.password)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the text";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, 6)
                    ],
                  ),
                ),
                margin: EdgeInsets.all(10),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        print(
                            'username =' + usernameController.text.toString());
                        print('Password =' + passworController.text.toString());
                        login(usernameController.text.toString(),
                            passworController.text.toString());
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              TextButton(onPressed: () {}, child: Text("Forgot Password?")),
              SizedBox(height: 70),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SIGN()));
                  },
                  child: const Text(
                    "RegisterNow?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  login(String username, String password) async {
    try {
      print("Webservice");
      print(username);
      print(password);
      var result;
      final Map<String, dynamic> logindata = {
        "username": username,
        "password": password,
      };
      final response = await http.post(
        Uri.parse(Webservice().mainurl + "login.php"),
        body: logindata,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        if (response.body.contains("success")) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
          prefs.setString("username", username);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Home();
          }));
        } else {
          print("login Failed");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text(
              "Login Failed",
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w200, color: Colors.red),
            ),
          ));
        }
      } else {
        result = {print(json.decode(response.body)['error'].toString())};
      }

      return result;
    } catch (e) {
      print(e.toString());
    }
  }
}
