import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFav;

  Product({
        @required this.description,
        @required this.title,
        @required this.id,
        this.isFav=false,
        @required this.price,
        @required this.imageUrl}
      );
  void toggleFav(){
    isFav = !isFav;
    notifyListeners();
  }
}
