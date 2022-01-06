import 'package:shop_app/provider/cart.dart';

class OrderItems{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}