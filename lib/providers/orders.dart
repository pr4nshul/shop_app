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
  String _token;
  final String _userId;
  List<OrderItem> get orders {
    return [..._orders];
  }
  Orders(this._token,this._orders,this._userId);
  Future<void> fetchSetOrders() async {
    final url = 'https://flutter-demo-fb276.firebaseio.com/orders/$_userId.json?auth=$_token';
    final response = await http.get(url);
    //print(json.decode(response.body));
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
    final url = 'https://flutter-demo-fb276.firebaseio.com/orders/$_userId.json?auth=$_token';
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
