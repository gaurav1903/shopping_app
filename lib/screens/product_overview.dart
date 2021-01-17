import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<ProductData>(context);
    final products = productdata.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          );
        });
  }
}
