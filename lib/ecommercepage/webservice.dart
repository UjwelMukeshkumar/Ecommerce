import 'dart:convert';
import 'dart:math';

import 'package:flutter_application_1/ecommercepage/model/productmodel.dart';
import 'package:http/http.dart' as http;

class Webservice {
  final imageurl = 'http://bootcamp.cyralearnings.com/products/';
  final mainurl = 'http://bootcamp.cyralearnings.com/';

  Future<List<ProductModel>> fetchcatproduts(int catid) async {
    final response = await http.post(
        Uri.parse(
            "http://bootcamp.cyralearnings.com/get_category_products.php"),
        body: {'catid ==' + catid.toString()});
    print("statuscode ==" + response.statusCode.toString());
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load category produts");
    }
  }
}
