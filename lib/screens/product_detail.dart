import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product_data.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedproduct =
        Provider.of<ProductData>(context, listen: false).findbyid(id);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(selectedproduct.title),
      // ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(selectedproduct.title),
            background: Hero(
              tag: selectedproduct.id,
              child: Image.network(
                selectedproduct.imageurl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10),
          Text(
            '${selectedproduct.price}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              selectedproduct.description,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(height: 600),
        ]))
      ]),
    );
  }
}
