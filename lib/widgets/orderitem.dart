import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as ord;
import 'package:date_format/date_format.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                formatDate(DateTime.now(), [dd, mm, yyyy, hh, mm, ss])
                    .toString()),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 150),
              child: ListView(
                children: widget.order.products.map((prod) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(prod.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        '${prod.quantity} x\$${prod.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
