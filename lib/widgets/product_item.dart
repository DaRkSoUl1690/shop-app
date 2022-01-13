import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (BuildContext context, product, Widget? child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: GridTile(
            child: Container(
              color: Colors.orange[300],
              child: Image.network(
                product.imageUrl,
              ),
            ),
            footer: GridTileBar(
              leading: Consumer<Product>(
                builder: (context, product, _) => IconButton(
                  onPressed: () {
                    product.toggleFavouriteStatus(authData.token,authData.userId!);
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {
                  cart.addItems(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added Item to the cart'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          }),
                    ),
                  );
                },
                color: Theme.of(context).colorScheme.secondary,
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
