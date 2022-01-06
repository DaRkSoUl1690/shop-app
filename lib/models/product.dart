import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
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
    this.isFavorite = false,
  });

  void _setFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final url =
        'https://shopapp-347e8-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFav(oldStatus);
      }
    } catch (e) {
        _setFav(oldStatus);
      
    }
  }
}
