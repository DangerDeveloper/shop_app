import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<Products>(context);
    final loadedProducts = showFavs ? listData.favoriteItems : listData.list;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            // where the list is use the use .Value method
            // loadedProducts are use because the list of product is present
            // in the products class.
//            builder: (ctx) => loadedProducts[i],
            value: loadedProducts[i],
            child: ProductItem(
//              title: loadedProducts[i].title,
//              id: loadedProducts[i].id,
//              imageUrl: loadedProducts[i].imageUrl,
                ),
          );
        });
  }
}
