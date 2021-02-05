import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/21.1%20badge.dart';
import 'package:shopping_app/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import 'package:http/http.dart' as http;

enum Filteropt { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isinit = true;
  bool showonlyfavourites = false;
  bool _isloading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<ProductData>(context).fetchProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<ProductData>(context).fetchProducts().then((value) {
        setState(() {
          _isloading = false;
        });
      });
      _isinit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: _isloading
            ? []
            : [
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
                    icon: Icon(Icons.more_vert)),
                Consumer<Cart>(
                  builder: (context, cartdata, ch) {
                    return Badge(
                        child: ch, value: cartdata.itemcount.toString());
                  },
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      return Navigator.of(context).pushNamed('/cartscreen');
                    },
                  ),
                ),
              ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showonlyfavourites),
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
