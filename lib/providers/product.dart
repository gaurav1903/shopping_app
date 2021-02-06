import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exception.dart';

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
  Future<void> togglefav() async {
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata/$id.json";
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      await http.patch(url, body: json.encode({'isfavourite': isFavourite}));
    } catch (e) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw HttpException("Can't change favourites right now");
    }
  }
}
