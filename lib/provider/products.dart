import 'package:flutter/foundation.dart';
import 'package:shopapp/provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _list = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // app wide filter use this approch
//  var _showFavoritesOnly = false;
//  void showFavoriteOnly(){
//    _showFavoritesOnly = true;
//    notifyListeners();
//  }
//  void showAll(){
//    _showFavoritesOnly = false;
//    notifyListeners();
//  }

  List<Product> get list {
    // app wide filter use this approch
//    if(_showFavoritesOnly){
//      return _list.where((prodItem)=> prodItem.isFavorite).toList();
//    }
    // return the copy of _list so outside the class
    // no one can change the list.
    return [..._list];
  }

  List<Product> get favoriteItems {
    return [..._list.where((prodItem) => prodItem.isFavorite).toList()];
  }

  Product findById(String id) {
    return _list.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(Product product) {
    const url = 'https://shop-app-2b4e0.firebaseio.com/products.json';
    return http
        .post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }))
        .then((response) {
      final newAddProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newAddProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _list.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _list[productIndex] = newProduct;
      notifyListeners();
    } else {
      // la la la...
    }
  }

  void deleteProduct(String id) {
    _list.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
