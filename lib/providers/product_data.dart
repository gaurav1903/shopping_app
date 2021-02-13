import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exception.dart';

class ProductData with ChangeNotifier {
  List<Product> _items = [];
  String authtoken;
  String userid;
  Map<String, int> already = {};
  // ProductData(this.authtoken, this._items);
  List<Product> get items {
    return [..._items];
  }

  void update(String autotoken, String id, List<Product> items) {
    authtoken = autotoken;
    _items = items;
    userid = id;
    for (Product x in _items) already[x.id] = 1;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    print('beginning fetching products');
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken& orderBy='creatorid'&equalTo='$userid'";
    try {
      print(userid);
      print(authtoken);
      final url2 =
          "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/users/$userid/favourites.json?auth=$authtoken";
      final response2 = await http.get(url2);
      print('second http request');
      print(response2.statusCode);
      final extractedresponse2 = json.decode(response2.body);
      print(extractedresponse2);
      final response = await http.get(url);
      final extracted_data = json.decode(response.body) as Map<String, dynamic>;
      if (extracted_data == null) return;
      extracted_data.forEach((id, prod_info) {
        if (already[id] == null) {
          addProd(Product(
            id: id,
            isFavourite: extractedresponse2 == null
                ? false
                : extractedresponse2[id] ?? false,
            title: prod_info['title'],
            description: prod_info['description'],
            imageurl: prod_info['imageurl'],
            price: prod_info['price'],
          ));
          already[id] = 1;
        }
      });

      notifyListeners();
    } catch (error) {
      print('error message -$error');
    }
  }

  void addProd(Product prod) {
    _items.insert(0, prod);
    notifyListeners();
  }

  Future<void> addProduct(Product prod) {
    print('adding status');
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken&orderBy='creatorid'&equalTo='$userid'";
    return http
        .post(url,
            body: json.encode({
              'title': prod.title,
              'description': prod.description,
              'imageurl': prod.imageurl,
              'price': prod.price,
              'creatorid': userid,
            }))
        .then((value) {
      print(json.decode(value.body));
      final newprod = Product(
          id: json.decode(value.body)['name'],
          title: prod.title,
          description: prod.description,
          imageurl: prod.imageurl,
          price: prod.price);
      _items.insert(0, newprod);
      //_items.add(val);
      already[newprod.id] = 1;
      notifyListeners();
    }).catchError((error) {
      print(error);
      print('eror caught');
      throw error;
    });
  }

  Future<void> updateproduct(String id, Product newproduct) async {
    final productindex = _items.indexWhere((element) => element.id == id);
    if (productindex >= 0) {
      final url =
          "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata/$id.json?auth=$authtoken";
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imageurl': newproduct.imageurl,
            'price': newproduct.price,
          }));
      _items[productindex] = newproduct;
      notifyListeners();
    } else {
      print('not in the list');
    }
  }

  Future<void> deleteproduct(String id) async {
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata/$id.json?auth=$authtoken";
    final prodindex = _items.indexWhere((element) => element.id == id);
    var existingprod = _items[prodindex];
    _items.removeWhere((element) => element.id == id);
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(prodindex, existingprod);
      throw HttpException('could not delete product');
    } else
      existingprod = null;
    already.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  Product findbyid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
