import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/details.dart';

import 'package:flutter_application_1/ecommercepage/webservice.dart';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// ignore: must_be_immutable
class Categoryproductspage extends StatefulWidget {
  String catname;
  int catid;
  Categoryproductspage({required this.catid, required this.catname, Key? key})
      : super(key: key);

  @override
  State<Categoryproductspage> createState() => _CategoryproductsState();
}

class _CategoryproductsState extends State<Categoryproductspage> {
  @override
  Widget build(BuildContext context) {
    log("catname =" + widget.catname.toString());
    log("catid =" + widget.catid.toString());

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
            widget.catname,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
            future: Webservice().fetchcatproduts(widget.catid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    crossAxisCount: 2,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return InkWell(
                          onTap: () {
                            log("clicked");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Detailspage(
                                  id: product.id!,
                                  name: product.productname!,
                                  image: Webservice().imageurl + product.image!,
                                  price: product.price.toString(),
                                  description: product.description);
                            }));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minHeight: 100, maxHeight: 250),
                                      child: Image(
                                          image: NetworkImage(
                                            Webservice().imageurl +
                                                product.image!,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            product.productname!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Rs .',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade900,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  product.price.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                    staggeredTileBuilder: (context) => StaggeredTile.fit(1));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
