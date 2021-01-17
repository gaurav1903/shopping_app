import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';

enum Filteropt { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showonlyfavourites = false;
  @override
  Widget build(BuildContext context) {
    final productcontainer = Provider.of<ProductData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only favourites'),
                        value: Filteropt.Favourites),
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: Filteropt.All,
                    )
                  ],
              onSelected: (Filteropt selectedvalue) {
                setState(() {
                  if (selectedvalue == Filteropt.Favourites)
                    showonlyfavourites = true;
                  else
                    showonlyfavourites = false;
                });
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: ProductGrid(showonlyfavourites),
    );
  }
}

class ProductGrid extends StatelessWidget {
  bool showonlyfavourites;
  ProductGrid(this.showonlyfavourites);
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<ProductData>(context);
    final products = productdata.items
        .where((element) => showonlyfavourites
            ? element.isFavourite == showonlyfavourites
            : true)
        .toList();
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
