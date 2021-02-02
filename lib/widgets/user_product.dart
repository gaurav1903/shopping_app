import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_data.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageurl;
  final String id;
  UserProductItem({this.title, this.imageurl, this.id});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/editproduct', arguments: id);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ProductData>(context, listen: false)
                    .deleteproduct(id);
              },
              color: Theme.of(context).errorColor),
        ]),
      ),
    );
  }
}
