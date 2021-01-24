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
      appBar: AppBar(
        title: Text(selectedproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                child: Image.network(
                  selectedproduct.imageurl,
                  fit: BoxFit.cover,
                )),
            SizedBox(height: 10),
            Text(
              '${selectedproduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedproduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
