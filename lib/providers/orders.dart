import 'package:flutter/material.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double price;
  final List<CartItem> products;

  OrderItem({this.id, this.price, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
      0,
      OrderItem(
          dateTime: DateTime.now(),
          id: DateTime.now().toString(),
          price: total,
          products: products),
    );
    notifyListeners();
  }
}
