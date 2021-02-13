import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
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
  String auth_token;
  String user_id;

  List<OrderItem> get orders {
    return [..._orders];
  }

  void updateinfo(String token, List<OrderItem> l, String userid) {
    auth_token = token;
    user_id = userid;
    _orders = l;
    notifyListeners();
  }

  Future<void> restore_orders() {
    print("atleast it's executing");
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/users/$user_id/orders.json?auth=$auth_token";
    return http.get(url).then((response) {
      final orderdata =
          json.decode(response.body) as Map<String, dynamic>; // map of map
      print(orderdata);
      _orders = [];
      List<CartItem> Cartitems = [];
      for (String key in orderdata.keys) {
        Cartitems = [];
        for (int i = 0; i < orderdata[key]['products'].length; i++) {
          final c = CartItem(
              id: orderdata[key]['products'][i]['id'],
              title: orderdata[key]['products'][i]['title'],
              quantity: orderdata[key]['products'][i]['quantity'],
              price: orderdata[key]['products'][i]['price']);
          Cartitems.add(c);
        }
        _orders.add(OrderItem(
            id: key,
            products: Cartitems,
            amount: orderdata[key]['amount'],
            datetime: DateTime.parse(orderdata[key]['datetime'])));
      }
    });

    //   for (String key in orderdata.keys) {
    //     List<CartItem> l = [];
    //     for (int i = 0; i < orderdata[key]['titles'].length; i++) {
    //       final t = CartItem(
    //           id: orderdata[key]['ids'][i],
    //           title: orderdata[key]['titles'][i],
    //           quantity: orderdata[key]['quantities'][i],
    //           price: orderdata[key]['prices'][i]);
    //       l.add(t);
    //     }
    //     if (already[key] == null) {
    //       _orders.add(OrderItem(
    //           id: key,
    //           products: l,
    //           amount: orderdata[key]['amount'],
    //           datetime: orderdata[key]['datetime']));
    //       already[key] = 1;
    //       notifyListeners();
    //     }
    //   }
    // }).catchError((e) {
    //   print(e);
    //   print('soooooo fuckeddd');
    // });
  }

  Future<void> addorders(List<CartItem> cartproducts, double total) {
    print(user_id);
    print(auth_token);
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/users/$user_id/orders.json?auth=$auth_token";
    return http
        .post(url,
            body: json.encode({
              'amount': total,
              'datetime': DateTime.now().toIso8601String(),
              'products': cartproducts
                  .map((item) => {
                        'id': item.id,
                        'title': item.title,
                        'quantity': item.quantity,
                        'price': item.price
                      })
                  .toList()
            }))
        .then((savedorder) {
      final m = json.decode(savedorder.body)['name'];
      _orders.insert(
          0,
          OrderItem(
              id: m,
              products: cartproducts,
              amount: total,
              datetime: DateTime.parse(m['datetime'])));
      notifyListeners();
    }).catchError((e) {
      print('you r sooooooo fuckeddddd');
      print(e);
    });
  }
}
