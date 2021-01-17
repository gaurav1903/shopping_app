import 'package:flutter/material.dart';
import 'file:///C:/Users/gaura/AndroidStudioProjects/shopping_app/lib/providers/product.dart';

class ProductData with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'warm and cozy',
        price: 19.99,
        imageurl:
            'https://cdnc.lystit.com/photos/96d3-2014/11/03/burberry-yellow-waffle-knit-cashmere-scarf-product-1-25175958-3-222045162-normal.jpeg'),
    Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'Red shirt',
        price: 10,
        imageurl:
            'https://cdn-s3.touchofmodern.com/products/000/845/741/1393825d5a2b9aac8bae7c360480a206_large.jpg?1508793045'),
    Product(
        id: 'p2',
        title: 'blue jacket',
        description: 'Blue woolen jacket',
        price: 100,
        imageurl:
            'https://www.ujackets.com/wp-content/uploads/2017/06/blue-wool-coat.jpg'),
    Product(
        id: 'p4',
        title: 'Coat',
        description: 'black coat',
        price: 500,
        imageurl:
            'https://media.mauvetree.com/wp-content/uploads/2018/04/Black-trench-coat-for-men.jpg')
  ];

  List<Product> get items {
    return [..._items];
  }

  void addProduct() {
    //_items.add(val);
    notifyListeners();
  }

  Product findbyid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
