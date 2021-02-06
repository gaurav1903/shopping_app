import 'package:flutter/material.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final String amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addorders(List<CartItem> cartproducts, double total) {
    // const url =
    //     "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/orders.json";
    // return http
    //     .patch(url,
    //         body: json.encode({
    //           'products': cartproducts,
    //           'amount': total,
    //           'datetime': DateTime.now()
    //         }))
    //     .then((savedorder) {
    //   print(savedorder.body);
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            products: cartproducts,
            amount: total.toString(),
            datetime: DateTime.now()));
    notifyListeners();
  }
}
