import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/lib/screens/cart_screen.dart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    label: Text('\$${cart.totalAmount}'),
                    backgroundColor: Colors.teal[100],
                  ),

                  // ignore: deprecated_member_use
                  OrderNow(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) => CartItemScreen(
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
                productId: cart.items.keys.toList()[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderNow extends StatefulWidget {
  final Cart cart;

  const OrderNow({Key? key, required this.cart}) : super(key: key);

  @override
  State<OrderNow> createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  var _loading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              try {
                setState(() {
                  _loading = true;
                });
                await Provider.of<Orders>(context, listen: false)
                    .addOrder(widget.cart.items.values.toList(),
                        widget.cart.totalAmount)
                    .then((_) {
                  setState(() {
                    _loading = false;
                  });
                });
              } catch (error) {
                rethrow;
              }
              widget.cart.clear();
            },
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : const Text('ORDER NOW'),
    );
  }
}
