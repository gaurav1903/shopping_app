import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/product_data.dart';
import '../widgets/user_product.dart';

class UserProduct extends StatelessWidget {
  Future<void> refresh(BuildContext ctx) async {
    await Provider.of<ProductData>(ctx).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print('status add');
              Navigator.of(context).pushNamed('/editproduct');
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh(context);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Consumer<ProductData>(builder: (ctx, product_data, _) {
            product_data.items.map((x) {
              print(x.id);
            });
            product_data.myitems.map((x) {
              print(x.id);
            });
            return ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    UserProductItem(
                      title: product_data.myitems[index].title,
                      imageurl: product_data.myitems[index].imageurl,
                      id: product_data.myitems[index].id,
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: product_data.myitems.length,
            );
          }),
        ),
      ),
    );
  }
}
