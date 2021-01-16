import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final String title;
  ProductDetail({this.title});
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
