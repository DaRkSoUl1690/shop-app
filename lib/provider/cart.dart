import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  get items {
    return {..._items};
  }

  get itemCount {
    return _items.length;
  }

  get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price + cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // changer quantity ...
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            price: value.price,
            quantity: value.quantity + 1,
            title: value.title),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}
