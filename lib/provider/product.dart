import 'dart:core';

import 'package:flutter/foundation.dart';


class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.description,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
  });

  void toggleFavouriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
