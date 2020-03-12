import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Total'),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount}'),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Oder Now'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx, index) => CartItemWidget(
                // if we use map like next
                title: cart.item.values.toList()[index].title,
                id: cart.item.values.toList()[index].id,
                price: cart.item.values.toList()[index].price,
                quantity: cart.item.values.toList()[index].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
