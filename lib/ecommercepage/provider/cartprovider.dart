import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartProduct> _list = [];
  List<CartProduct> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total = total + (item.price * item.qty);
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    int id,
    String name,
    double price,
    int qty,
    String imagesUrl,
  ) {
    final product = CartProduct(
      id: id,
      name: name,
      price: price,
      qty: qty,
      iamgesUrl: imagesUrl,
    );
    _list.add(product);
    notifyListeners();
    print("add products");
  }

  void increment(CartProduct product) {
    product.increase();
    notifyListeners();
  }

  void reducedByOne(CartProduct product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(CartProduct product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart(CartProduct product) {
    _list.clear();
    notifyListeners();
  }
}

class CartProduct {
  int id;
  String name;
  double price;
  int qty = 1;
  String iamgesUrl;

  CartProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.iamgesUrl,
  });
  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        qty: json["qty"],
        iamgesUrl: json["imagesUrl"],
      );

  Map<String, dynamic> tojson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": iamgesUrl,
        "qty": qty,
      };
  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}
