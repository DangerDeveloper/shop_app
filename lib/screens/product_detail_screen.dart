import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300.0,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.0,),
          Text('\$${product.price}'),
          SizedBox(height: 20.0,),
          Container(
            width: double.infinity,
            child: Text(product.description),
          ),
        ],
      ),
    );
  }
}
