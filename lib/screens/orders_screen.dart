import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/orders.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routName = '/OrdersScreen';

  @override
  Widget build(BuildContext context) {
//    final orderData = Provider.of<Orders>(context);
    print('Only one time');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              //..sn
              // error handling
              return Center(
                child: Text('An error.'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => OrderItemWidget(
                    orderData.orders[index],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
