import 'package:shop_app/models/cart_item_model.dart';

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