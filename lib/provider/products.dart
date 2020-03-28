import 'package:flutter/foundation.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _list = [];

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

  final String _authToken;
  final String _userId;

  Products(this._authToken, this._userId, this._list);

  List<Product> get favoriteItems {
    return [..._list.where((prodItem) => prodItem.isFavorite).toList()];
  }

  Product findById(String id) {
    return _list.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    var url =
        'https://shop-app-2b4e0.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-2b4e0.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      List<Product> addProduct = [];
      extractedData.forEach((productId, productData) {
        addProduct.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _list = addProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-2b4e0.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      final newAddProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newAddProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

//  Future<void> addProduct(Product product) {
//    const url = 'https://shop-app-2b4e0.firebaseio.com/products.json';
//    return http
//        .post(url,
//        body: json.encode({
//          'title': product.title,
//          'description': product.description,
//          'price': product.price,
//          'imageUrl': product.imageUrl,
//          'isFavorite': product.isFavorite,
//        }))
//        .then((response) {
//      final newAddProduct = Product(
//        id: json.decode(response.body)['name'],
//        title: product.title,
//        description: product.description,
//        price: product.price,
//        imageUrl: product.imageUrl,
//      );
//      _list.add(newAddProduct);
//      notifyListeners();
//    }).catchError((error) {
//      throw error;
//    });
//  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _list.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'https://shop-app-2b4e0.firebaseio.com/products/$id.json?auth=$_authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _list[productIndex] = newProduct;
      notifyListeners();
    } else {
      // la la la...
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-2b4e0.firebaseio.com/products/$id.json?auth=$_authToken';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('Could not Delete Product');
    } else {
      _list.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}

//  Future<void> deleteProduct(String id) async {
//    final url = 'https://shop-app-2b4e0.firebaseio.com/products/$id';
//    final existingProductIndex = _list.indexWhere((prod) => prod.id == id);
//    var existingProduct = _list[existingProductIndex];
//    _list.removeAt(existingProductIndex);
//    notifyListeners();
//    final response = await http.delete(url);
//    if (response.statusCode >= 400) {
//      _list.insert(existingProductIndex, existingProduct);
//      notifyListeners();
//      throw HttpException('Could not Delete Product');
//    }
//    existingProduct = null;
//  }
//}

//Product(
//id: 'p1',
//title: 'Red Shirt',
//description: 'A red shirt - it is pretty red!',
//price: 29.99,
//imageUrl:
//'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//),
//Product(
//id: 'p2',
//title: 'Trousers',
//description: 'A nice pair of trousers.',
//price: 59.99,
//imageUrl:
//'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//),
//Product(
//id: 'p3',
//title: 'Yellow Scarf',
//description: 'Warm and cozy - exactly what you need for the winter.',
//price: 19.99,
//imageUrl:
//'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//),
//Product(
//id: 'p4',
//title: 'A Pan',
//description: 'Prepare any meal you want.',
//price: 49.99,
//imageUrl:
//'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//),
