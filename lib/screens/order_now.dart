import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/orders.dart';

class OrderNow extends StatefulWidget {
  const OrderNow(Key? key) : super(key: key);

  @override
  State<OrderNow> createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  var _loading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: cart.totalAmount <= 0
          ? null
          : () async {
              try {
                setState(() {
                  _loading = true;
                });
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(
                  cart.items.values.toList(),
                  cart.totalAmount,
                )
                    .then((_) {
                  setState(() {
                    _loading = false;
                  });
                });
              } catch (error) {
                rethrow;
              }
              cart.clear();
            },
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : const Text('ORDER NOW'),
    );
  }
}
