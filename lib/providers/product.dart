import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageurl;
  bool isFavourite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageurl,
      this.isFavourite = false,
      @required this.price});
  void togglefav() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
