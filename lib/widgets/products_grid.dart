import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFav;
  ProductsGrid(this.isFav);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final loadedProducts = isFav ? productProvider.favItems :productProvider.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2.5,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(
            // title: loadedProducts[i].title,
            // imageUrl: loadedProducts[i].imageUrl,
            // id: loadedProducts[i].id,
            ),
      ),
      itemCount: loadedProducts.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
