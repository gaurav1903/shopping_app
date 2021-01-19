import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String prodid;
  CartItemWidget({this.quantity, this.price, this.title, this.id, this.prodid});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeitem(prodid);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$${price}')),
            ),
            title: Text(title),
            subtitle: Text('Total :\$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
