import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem(
      {@required this.title,
      @required this.id,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem({String id, double price, String title}) {
    if (_items.containsKey(id))
      _items.update(
          id,
          (existingcartitem) => CartItem(
              id: existingcartitem.id,
              title: existingcartitem.title,
              price: existingcartitem.price,
              quantity: existingcartitem.quantity + 1));
    else
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    notifyListeners();
  }

  void removeitem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  int get itemcount {
    return _items.length;
  }

  double get totalamount {
    double sum = 0.0;
    _items.forEach((key, cartitem) {
      sum += (cartitem.price * cartitem.quantity);
    });
    return sum;
  }

  void clearcart() {
    _items = {};
    notifyListeners();
  }
}
