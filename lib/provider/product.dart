import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// use ChangeNotifier because is Favorite is change and the toggleFavoriteStatus
// is use in the class.
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    final url = 'https://shop-app-2b4e0.firebaseio.com/products/$id.json';
    final oldFev = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldFev;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldFev;
      notifyListeners();
    }
  }
}
