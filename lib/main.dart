import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/order_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/product_provider.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_Screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.pinkAccent,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
//class MyHomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold();
//  }
//}
//
