import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/product_overview.dart';
import 'package:shopping_app/screens/splash_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, ProductData>(
            create: (_) => ProductData(),
            update: (ctx, auth_object, previousprod) {
              return previousprod
                ..update(
                    auth_object.token, auth_object.userid, previousprod.items);
            }),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, auth_obj, previousorders) {
              return previousorders
                ..updateinfo(
                    auth_obj.token, previousorders.orders, auth_obj.userid);
            })
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
            home: authdata.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authdata.tryautologin(),
                    builder: (ctx, authresult) {
                      return (authresult.connectionState ==
                              ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen();
                    }));
      }),
    );
  }
}
