import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String? id;
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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String? token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final url =
        'https://shopapp-347e8-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
