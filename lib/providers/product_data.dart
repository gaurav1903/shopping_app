import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/exception.dart';

class ProductData with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'warm and cozy',
    //     price: 19.99,
    //     imageurl:
    //         'https://cdnc.lystit.com/photos/96d3-2014/11/03/burberry-yellow-waffle-knit-cashmere-scarf-product-1-25175958-3-222045162-normal.jpeg'),
    // Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'Red shirt',
    //     price: 10,
    //     imageurl:
    //         'https://cdn-s3.touchofmodern.com/products/000/845/741/1393825d5a2b9aac8bae7c360480a206_large.jpg?1508793045'),
    // Product(
    //     id: 'p2',
    //     title: 'blue jacket',
    //     description: 'Blue woolen jacket',
    //     price: 100,
    //     imageurl:
    //         'https://www.ujackets.com/wp-content/uploads/2017/06/blue-wool-coat.jpg'),
    // Product(
    //     id: 'p4',
    //     title: 'Coat',
    //     description: 'black coat',
    //     price: 500,
    //     imageurl:
    //         'https://media.mauvetree.com/wp-content/uploads/2018/04/Black-trench-coat-for-men.jpg')
  ];
  final String authtoken;
  ProductData(this.authtoken, this._items);
  List<Product> get items {
    return [..._items];
  }

  Map<String, int> already = {};
  Future<void> fetchProducts() async {
    final url =
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken";
    try {
      final response = await http.get(url);
      final extracted_data = json.decode(response.body) as Map<String, dynamic>;
      if (extracted_data == null) return;
      extracted_data.forEach((id, prod_info) {
        if (already[id] == null) {
          addProd(Product(
              id: id,
              title: prod_info['title'],
              description: prod_info['description'],
              imageurl: prod_info['imageurl'],
              price: prod_info['price'],
              isFavourite: prod_info['isfavourite']));
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
        "https://shopping-app-2cb0f-default-rtdb.firebaseio.com/productdata.json?auth=$authtoken";
    return http
        .post(url,
            body: json.encode({
              'title': prod.title,
              'description': prod.description,
              'imageurl': prod.imageurl,
              'price': prod.price,
              'isfavourite': prod.isFavourite,
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
