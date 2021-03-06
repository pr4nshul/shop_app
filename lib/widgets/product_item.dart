import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_details_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final errorScaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context,listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: GridTile(
        child: Image.network(product.imageUrl),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              try {
                await product.toggleFav(auth.token,auth.userId);
              } catch (error) {
                errorScaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Can\'t do that right now!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.black87,
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart_outlined),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
