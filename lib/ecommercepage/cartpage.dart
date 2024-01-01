import 'package:flutter/material.dart';
import 'package:flutter_application_1/ecommercepage/chechoutpage.dart';
import 'package:flutter_application_1/ecommercepage/provider/cartprovider.dart';
import 'package:provider/provider.dart';

class Cartpage extends StatelessWidget {
  List<CartProduct> cartlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:  Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        actions: [
          context.watch<CartProvider>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    context.read<CartProvider>().clearCart;
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 56, 55, 55),
                  ))
        ],
      ),
      body: context.watch<CartProvider>().getItems.isEmpty
          ? Center(
              child: Text("Empty Cart"),
            )
          : Consumer<CartProvider>(
              builder: (context, cart, child) {
                cartlist = cart.getItems;
                return ListView.builder(
                    itemCount: cart.count,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 9),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                cartlist[index].iamgesUrl),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            cartlist[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cartlist[index]
                                                    .price
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.redAccent),
                                              ),
                                              Container(
                                                height: 35,
                                                color: Colors.grey.shade600,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        cartlist[index].qty == 1
                                                            ? cart.removeItem(
                                                                cart.getItems[
                                                                    index])
                                                            : cart.reducedByOne(
                                                                cartlist[
                                                                    index]);
                                                      },
                                                      icon: Icon(
                                                        Icons.minimize_rounded,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      cartlist[index]
                                                          .qty
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        cart!.increment(
                                                            cartlist[index]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.watch<CartProvider>().totalPrice.toString(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  color: Colors.greenAccent),
            ),
            InkWell(
              onTap: () {
                context.watch<CartProvider>().getItems.isEmpty
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: const Text(
                            "Cart is Empty",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Checkout(cart: cartlist);
                          },
                        ),
                      );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2.2,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Text(
                    "Order Now",
                    style: TextStyle(fontSize: 29, color: Colors.white12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
