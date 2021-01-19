import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/product_overview.dart';
import 'screens/product_detail.dart';
import 'package:provider/provider.dart';
import 'providers/product_data.dart';
import 'providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProductData();
        }),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          '/productdetail': (_) => ProductDetail(),
          '/cartscreen': (_) => CartScreen(),
        },
        home: ProductOverviewScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
