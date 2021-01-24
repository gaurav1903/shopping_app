import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/product_data.dart';
import '../widgets/user_product.dart';

class UserProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product_data = Provider.of<ProductData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                UserProductItem(
                  title: product_data.items[index].title,
                  imageurl: product_data.items[index].imageurl,
                ),
                Divider()
              ],
            );
          },
          itemCount: product_data.items.length,
        ),
      ),
    );
  }
}
