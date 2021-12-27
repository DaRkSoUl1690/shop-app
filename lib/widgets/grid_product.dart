import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showfavs;
  ProductGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = !showfavs ? productsData.items : productsData.favorite;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
        value: products[i],
        child: const ProductItem(),
      ),
    );
  }
}
