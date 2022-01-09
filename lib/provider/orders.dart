import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/orderitem.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://shopapp-347e8-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(Uri.parse(url));
    var extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      notifyListeners();
      return;
    } else {
      final List<OrderItems> loadedOrders = [];
      extractedData.forEach((key, orderData) {
        loadedOrders.add(
          OrderItems(
            id: key,
            amount: orderData["amount"],
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    const url = 'https://shopapp-347e8-default-rtdb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'products': cartproducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
            'dateTime': timeStamp.toString(),
          }));

      _orders.insert(
        0,
        OrderItems(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartproducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
