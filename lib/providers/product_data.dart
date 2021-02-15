import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exception.dart';

class ProductData with ChangeNotifier {
  List<Product> _items = [];
  String authtoken;
  List<Product> myitems = [];
  String userid;
  // Map<String, int> already = {};
  // ProductData(this.authtoken, this._items);
  List<Product> get items {
    return [..._items];
  }

  void update(String autotoken, String id, List<Product> items) {
    authtoken = autotoken;
    _items = items;
    userid = id;
    // for (Product x in _items) already[x.id] = 1;
    notifyListeners();
  }

  Future<void> fetchProducts([bool filter = false]) async {
    _items = [];
    myitems = [];
    print('beginning fetching products');
    final url =
        'https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken';
    try {
      // print(userid);
      // print(authtoken);
      final response = await http.get(url);
      // print(response.statusCode);
      final extracted_data = json.decode(response.body) as Map<String, dynamic>;
      // print(extracted_data);
      var extractedresponse2 = null;

      final url2 =
          "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/users/$userid/favourites.json?auth=$authtoken";
      final response2 = await http.get(url2);
      // print('second http request');
      // print(response2.statusCode);
      extractedresponse2 = json.decode(response2.body);
      // print(extractedresponse2);

      if (extracted_data == null) return;
      extracted_data.forEach((id, prod_info) {
        // if (already[id] == null) {
        Product x = Product(
          id: id,
          isFavourite: extractedresponse2 == null
              ? false
              : extractedresponse2[id] ?? false,
          title: prod_info['title'],
          description: prod_info['description'],
          imageurl: prod_info['imageurl'],
          price: prod_info['price'],
        );
        addProd(x);
        if (prod_info['creatorid'] == userid) myitems.add(x);
        // already[id] = 1;
        // }
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
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken";
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
      myitems.insert(0, newprod);
      //_items.add(val);
      // already[newprod.id] = 1;
      notifyListeners();
    }).catchError((error) {
      print(error);
      print('eror caught');
      throw error;
    });
  }

  Future<void> updateproduct(String id, Product newproduct) async {
    print('updating -2');
    print(newproduct.title);
    print(newproduct.imageurl);
    print(id);
    final productindex = _items.indexWhere((element) => element.id == id);
    final index2 = myitems.indexWhere((element) => element.id == id);
    if (productindex >= 0) {
      final url =
          "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata/$id.json?auth=$authtoken";
      final response = await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imageurl': newproduct.imageurl,
            'price': newproduct.price,
          }));
      print(response.statusCode);
      print(json.decode(response.body));
      _items[productindex] = newproduct;
      print('printiting items id');
      _items.map((e) {
        print(e.id);
      });
      myitems[index2] = newproduct;
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
    final prodindex2 = myitems.indexWhere((element) => element.id == id);
    _items.removeWhere((element) => element.id == id);
    myitems.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(prodindex, existingprod);
      myitems.insert(prodindex2, existingprod);
      notifyListeners();
      throw HttpException('could not delete product');
    } else
      existingprod = null;
    // already.removeWhere((key, value) => key == id);
  }

  Product findbyid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
