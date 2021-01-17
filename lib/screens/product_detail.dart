import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product_data.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedproduct = Provider.of<ProductData>(context, listen: false)
        .findbyid(id) as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedproduct.title),
      ),
    );
  }
}
