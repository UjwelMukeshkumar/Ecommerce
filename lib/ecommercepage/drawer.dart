import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/cartpage.dart';
import 'package:flutter_application_1/ecommercepage/home.dart';
import 'package:flutter_application_1/ecommercepage/loginpaaage.dart';
import 'package:flutter_application_1/ecommercepage/orderdetails.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with app logo or name
            const DrawerHeader(
              child: CircleAvatar(),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Divider(color: Colors.black26),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              ),
            ),
            Divider(color: Colors.black26),
            ListTile(
                leading: Icon(Icons.shopping_cart_rounded, color: Colors.black),
                title: Text("Cart page", style: TextStyle(fontSize: 16)),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Cartpage()))),
            Divider(color: Colors.black26),
            ListTile(
              leading: Icon(Icons.list_alt, color: Colors.black),
              title: Text("Orders", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Orderdetails())),
              // ...
            ),
            Divider(color: Colors.black26),
            const ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text("Settings", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              // ...
            ),
            Divider(color: Colors.black26),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LOGIN()))),
          ],
        ),
      ),
    );
  }
}
