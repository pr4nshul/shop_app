import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

enum Filter { FavOnly, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool onlyFav = false;
  bool init = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (init) {
      _isLoading = true;
      Provider.of<ProductProvider>(context).setFetchProducts().then((_) {
        _isLoading = false;
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (Filter selected) {
              setState(() {
                if (selected == Filter.FavOnly) {
                  onlyFav = true;
                } else {
                  onlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favourites'),
                value: Filter.FavOnly,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: Filter.ShowAll,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_sharp,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ], //itemBuilder
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(onlyFav),
    );
  }
}
