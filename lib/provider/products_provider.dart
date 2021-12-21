import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
        id: 'p1',
        description: 'Apple iPhone 12th generation',
        title: 'iPhone 12 Pro',
        price: 999,
        imageUrl:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-12-pro-blue-hero?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1604021661000',
        isFavorite: false),
    Product(
        id: 'p2',
        description: 'Apple iPhone 12th generation',
        title: 'Apple phone hai',
        price: 999,
        imageUrl:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-12-pro-blue-hero?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1604021661000',
        isFavorite: false),
    Product(
        id: 'p3',
        description: 'Apple iPhone 12th generation',
        title: 'iPhone 12 Pro',
        price: 999,
        imageUrl:
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-12-pro-blue-hero?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1604021661000',
        isFavorite: false),
  ];

  //modified by me
   List<Product> get items {
    return [..._items];
  }
  
  List<Product> get favorite {
    return _items.where((probItem) => probItem.isFavorite).toList();
  }

  Product findById(String id) => _items.firstWhere((prod) => prod.id == id);

  void addProduct() {
    //_items.add(value);
    notifyListeners();
  }
}
