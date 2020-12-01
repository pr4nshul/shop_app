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

  Future<void> toggleFav(String token,String userId) async {
    final url = 'https://flutter-demo-fb276.firebaseio.com/userFavouriteProducts/$userId/$id.json?auth=$token';
    isFav = !isFav;
    notifyListeners();
    final response =await http.put(
        url,
        body: json.encode(
          isFav
        ),
      );
    if(response.statusCode>=400){
      isFav = !isFav;
      notifyListeners();
      throw HttpException('Error');
    }
  }
}
