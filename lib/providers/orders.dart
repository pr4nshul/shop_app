import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> fetchSetOrders() async {
    const url = 'https://flutter-demo-bc8c7.firebaseio.com/orders.json';
    final response = await http.get(url);
    print(json.decode(response.body));
    final extractedData =
        json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null){
      return;
    }
    List<OrderItem> loadedProducts = [];
    extractedData.forEach(
      (orderId, orderData) {
        loadedProducts.add(
          OrderItem(
            id: orderId,
            price: orderData['price'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    price: item['price'],
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    _orders = loadedProducts;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    const url = 'https://flutter-demo-bc8c7.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'dateTime': timestamp.toIso8601String(),
          'price': total,
          'products': products
              .map(
                (cp) => {
                  'id': cp.id,
                  'price': cp.price,
                  'quantity': cp.quantity,
                  'title': cp.title,
                },
              )
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
          dateTime: timestamp,
          id: json.decode(response.body)['name'],
          price: total,
          products: products),
    );
    notifyListeners();
  }
}
