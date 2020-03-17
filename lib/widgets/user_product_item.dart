import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routName, arguments: id);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context).deleteProduct(id);
                  } catch (error) {
                    scaffold.removeCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Deleting Faild'),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
