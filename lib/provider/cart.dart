

import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.price, this.title, this.id, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get cartCount {
    return _item.length;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, cart) {
      total += (cart.price * cart.quantity);
    });
    return total;
  }

  void removeOne(String productId){
    if(!_item.containsKey(productId)){
      return;
    }
    if(_item[productId].quantity > 1){
      _item.update(productId, (oldCardItem) => CartItem(
        id: oldCardItem.id,
        title: oldCardItem.title,
        price: oldCardItem.price,
        quantity: oldCardItem.quantity - 1,
      ));
    } else {
      _item.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_item.containsKey(productId)) {
      // change Quantity
      _item.update(
          productId,
          (oldProduct) => CartItem(
                id: oldProduct.id,
                price: oldProduct.price,
                title: oldProduct.title,
                quantity: oldProduct.quantity + 1,
              ));
    } else {
      // Add new item in cart
      _item.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void remove(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }
}
