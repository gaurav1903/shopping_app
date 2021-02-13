import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exception.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

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
  Future<void> togglefav(String token, String userid) async {
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/users/$userid/favourites/$id.json?auth=$token";
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        throw HttpException("dont you mess with the program");
      }
    } catch (e) {
      print(e);
      isFavourite = !isFavourite;
      notifyListeners();
      throw HttpException("Can't change favourites right now");
    }
  }
}
