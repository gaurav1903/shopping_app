import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            '\$ ${cart.totalamount.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText2
                                    .color),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isloading = true;
                            });
                            Provider.of<Orders>(context, listen: false)
                                .addorders(cart.items.values.toList(),
                                    cart.totalamount)
                                .then((response) {
                              cart.clearcart();
                              Navigator.of(context)
                                  .popAndPushNamed('/orderscreen');
                            }).catchError((e) {
                              print(e);
                            });
                          },
                          child: Text(
                            'Place Order',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                  itemCount: cart.itemcount,
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      id: cart.items.values.toList()[index].id,
                      prodid: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      quantity: cart.items.values.toList()[index].quantity,
                      price: cart.items.values.toList()[index].price,
                    );
                  },
                ))
              ],
            ),
    );
  }
}
