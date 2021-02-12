import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/product_overview.dart';
import 'package:shopping_app/screens/user_product.dart';
import 'screens/edit_product_screen.dart';
import 'screens/product_detail.dart';
import 'package:provider/provider.dart';
import 'providers/product_data.dart';
import 'providers/orders.dart';
import './screens/orderscreen.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductData>(create: (_) {
          return ProductData(authtoken, _items);
        }, update: (ctx, auth_object, previousprod) {
          return ProductData(auth_object.token,
              previousprod == null ? [] : previousprod.items);
        }),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      child: Consumer<Auth>(builder: (ctx, authdata, _) {
        return MaterialApp(
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
            '/orderscreen': (_) => OrderScreen(),
            '/userproduct': (_) => UserProduct(),
            '/editproduct': (_) => EditProductScreen(),
          },
          home: authdata.isAuth ? ProductOverviewScreen() : AuthScreen(),
        );
      }),
    );
  }
}
