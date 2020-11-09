import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFav;

  Product(
      {@required this.description,
      @required this.title,
      @required this.id,
      this.isFav = false,
      @required this.price,
      @required this.imageUrl});

  Future<void> toggleFav() async {
    final url = 'https://flutter-demo-bc8c7.firebaseio.com/products/$id.json';
    isFav = !isFav;
    notifyListeners();
    final response =await http.patch(
        url,
        body: json.encode(
          {
            'isFavourite': isFav,
          },
        ),
      );
    if(response.statusCode>=400){
      isFav = !isFav;
      notifyListeners();
      throw HttpException('Error');
    }
  }
}
