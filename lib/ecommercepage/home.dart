import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/categoryproducts.dart';

import 'package:flutter_application_1/ecommercepage/drawer.dart';
import 'package:flutter_application_1/ecommercepage/model/productmodel.dart';

import 'package:flutter_application_1/ecommercepage/model/categorymodel.dart';
import 'package:flutter_application_1/ecommercepage/webservice.dart';

import 'package:http/http.dart' as http;
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 119, 122, 126),
          centerTitle: true,
          title:
              Text("360 DEGREE", style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    height: 50,
                    color: Colors.white,
                    child: const Text(
                      "Category",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                    future: fetchCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("length ==" + snapshot.data!.length.toString());
                        return Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    print("Clicked");
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Categoryproductspage(
                                        catid: snapshot.data![index].id!,
                                        catname:
                                            snapshot.data![index].category!,
                                      );
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data![index].category!,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 118, 100, 100),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    height: 30,
                    child: const Text(
                      "Offer Products",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("length ==" + snapshot.data!.length.toString());
                        return Container(
                          height: screenHeight,
                          child: StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              final _product = snapshot.data![index];
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    print("Clicked");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detailspage(
                                                id: snapshot.data![index].id,
                                                name: snapshot
                                                    .data![index].productname,
                                                image:
                                                    snapshot.data![index].image,
                                                price:
                                                    snapshot.data![index].price,
                                                description: snapshot
                                                    .data![index]
                                                    .description)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 184, 194, 199),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(children: [
                                        ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(15)),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  minHeight: 150,
                                                  maxHeight: 250),
                                              margin: EdgeInsets.all(10),
                                              child: Image(
                                                image: NetworkImage(
                                                    Webservice().imageurl +
                                                        _product.image),
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _product.productname!,
                                                  //  "Shoes ssssssssssssssssssssssssssssssss",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Rs. ' +
                                                      _product.price.toString(),
                                                  //  "2000",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 85, 28, 183),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(1),
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 3,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              )),
        ));
  }

  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.post(Uri.parse(
        "http://bootcamp.cyralearnings.com/getcategories.php",
      ));
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        final parsed =
            await json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromjson(json))
            .toList();
      } else {
        throw Exception("Failed to load Category");
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
        Uri.parse("http://bootcamp.cyralearnings.com/view_offerproducts.php"));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load Caategory");
    }
  }
}
