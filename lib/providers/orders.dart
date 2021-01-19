import 'package:flutter/material.dart';
import 'cart.dart';

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
    return [...orders];
  }

  void addorders(List<CartItem> cartproducts, double total) {
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
