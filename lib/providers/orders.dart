import 'package:flutter/material.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final String amount;
  final List<CartItem> products;
  final String datetime;

  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String token;
  Map<String, int> already = {};
  List<OrderItem> get orders {
    return [..._orders];
  }

  void updateinfo(String token, List<OrderItem> l) {
    token = token;
    _orders = l;
    for (OrderItem orderitem in _orders) {
      already[orderitem.id] = 1;
    }
    notifyListeners();
  }

  Future<void> restore_orders() {
    print("atleast it's executing");
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/orders.json?auth=$token";
    return http.get(url).then((response) {
      final orderdata =
          json.decode(response.body) as Map<String, dynamic>; //map of map
      for (String key in orderdata.keys) {
        List<CartItem> l = [];
        for (int i = 0; i < orderdata[key]['titles'].length; i++) {
          final t = CartItem(
              id: orderdata[key]['ids'][i],
              title: orderdata[key]['titles'][i],
              quantity: orderdata[key]['quantities'][i],
              price: orderdata[key]['prices'][i]);
          l.add(t);
        }
        if (already[key] == null) {
          _orders.add(OrderItem(
              id: key,
              products: l,
              amount: orderdata[key]['amount'],
              datetime: orderdata[key]['datetime']));
          already[key] = 1;
          notifyListeners();
        }
      }
    }).catchError((e) {
      print(e);
      print('soooooo fuckeddd');
    });
  }

  Future<void> addorders(List<CartItem> cartproducts, double total) {
    // final double price;
    // final int quantity;
    // final String title;
    // final String prodid;
    List<String> titles = [];
    List<double> prices = [];
    List<int> quantities = [];
    List<String> ids = [];
    const url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/orders.json";
    for (var x in cartproducts) {
      titles.add(x.title);
      prices.add(x.price);
      quantities.add(x.quantity);
      ids.add(x.id);
    }
    return http
        .post(url,
            body: json.encode({
              'titles': titles,
              'prices': prices,
              'quantities': quantities,
              'ids': ids,
              'amount': total.toString(),
              'datetime': DateTime.now().toString()
            }))
        .then((savedorder) {
      final m = json.decode(savedorder.body)['name'];
      _orders.insert(
          0,
          OrderItem(
              id: m,
              products: cartproducts,
              amount: total.toString(),
              datetime: DateTime.now().toString()));
      already[m] = 1;
      notifyListeners();
    }).catchError((e) {
      print('you r sooooooo fuckeddddd');
      print(e);
    });
  }
}
