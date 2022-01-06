import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/orderitem.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  final List<OrderItems> _orders = [];

  get orders {
    return [..._orders];
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
      print(json.decode(response.body));

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
    } catch (error) {}
  }
}
