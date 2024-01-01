import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/loginpaaage.dart';
import 'package:http/http.dart' as http;

class SIGN extends StatefulWidget {
  const SIGN({super.key});

  @override
  State<SIGN> createState() => _SIGNState();
}

class _SIGNState extends State<SIGN> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.redAccent),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
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
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Name",
                            labelText: "Name",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Phone Number",
                            labelText: "Contact Number",
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Address",
                            labelText: "Address",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the username",
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the field';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the Password",
                            labelText: "Password",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
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
                          print("name =" + nameController.toString());
                          print("phone =" + phoneController.toString());
                          print("address =" + addressController.toString());
                          print("username =" + usernameController.toString());
                          print("password =" + passwordController.toString());

                          sign(
                              nameController.text,
                              phoneController.text,
                              addressController.text,
                              usernameController.text,
                              passwordController.text);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => LOGIN()),
                            ),
                          );
                        }
                        ;
                      },
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  sign(String name, phone, address, username, password) async {
    try {
      print(username);
      print(password);
      var result;
      final Map<String, dynamic> signdata = {
        "name": name,
        "phone": phone,
        "adress": address,
        "username": username,
        "password": password,
      };
      final response = await http.post(
          Uri.parse(" http://bootcamp.cyralearnings.com/registration.php"),
          body: signdata);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        if (response.body.contains("sucess")) {
          print("regitration Sucessfully Completed");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Text(
              "REGESTRATION SUCESSFULLY COMPLETED",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LOGIN(),
              ));
        } else {
          print("reggistration faileed");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Text(
              "REGESTRATION SUCESSFULLY COMPLETED",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.blue),
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
