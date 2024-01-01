import 'package:flutter/material.dart';

class ViewallCategories extends StatefulWidget {
  const ViewallCategories({super.key});

  @override
  State<ViewallCategories> createState() => _ViewallCategoriesState();
}

class _ViewallCategoriesState extends State<ViewallCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.grey.shade100,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Categories",
        style: TextStyle(fontSize: 2, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
