import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product>? _items = [];

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://shopapp-347e8-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopapp-347e8-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach(
        (key, value) {
          loadedProduct.add(
            Product(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite: favoriteData[key] ?? false,
            ),
          );
        },
      );
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {}
  }

  //modified by me
  List<Product> get items {
    return [..._items!];
  }

  List<Product> get favorite {
    return _items!.where((probItem) => probItem.isFavorite).toList();
  }

  Product findById(String id) => _items!.firstWhere((prod) => prod.id == id);

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-347e8-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        isFavorite: product.isFavorite,
        imageUrl: product.imageUrl,
      );
      _items!.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items!.indexWhere((prob) => prob.id == id);

    if (prodIndex >= 0) {
      final url =
          'https://shopapp-347e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items![prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp-347e8-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items!.indexWhere((element) => element.id == id);
    Product? existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete Product.');
    }
    existingProduct = null;
  }
}
