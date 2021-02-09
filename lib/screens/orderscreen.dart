import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/orderitem.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);
    return RefreshIndicator(
      onRefresh: () {
        return Provider.of<Orders>(context, listen: false).restore_orders();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Your Orders'),
          ),
          drawer: AppDrawer(),
          body: FutureBuilder(
              future:
                  Provider.of<Orders>(context, listen: false).restore_orders(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else
                  return Consumer<Orders>(builder: (ctx, orderdata, _) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                          itemCount: orderdata.orders.length,
                          itemBuilder: (context, index) =>
                              OrderItem(orderdata.orders[index])),
                    );
                  });
              })),
    );
  }
}
