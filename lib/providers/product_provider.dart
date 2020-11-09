import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => id == element.id);
  }

  Future<void> setFetchProducts() async {
    const url = 'https://flutter-demo-bc8c7.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
      List<Product> loadedItems = [];
      extractedData.forEach((id, data) {
        loadedItems.add(
          Product(
            id: id,
            imageUrl: data['imageUrl'],
            description: data['description'],
            price: data['price'],
            title: data['title'],
            isFav: data['isFavourite'],
          ),
        );
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addItem(Product product) async {
    const url = 'https://flutter-demo-bc8c7.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'price': product.price,
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFav,
          }));
      final newProduct = Product(
          title: product.title,
          price: product.price,
          id: json.decode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateItem(String id, Product product) async{
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          'https://flutter-demo-bc8c7.firebaseio.com/products/$id.json';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      _items[index] = product;
    }
    notifyListeners();
  }

  Future<void> delete(String id) async{
    final url = 'https://flutter-demo-bc8c7.firebaseio.com/products/$id.json';
    final index = _items.indexWhere((element) => element.id==id);
    var product = _items[index];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode>=400){
      _items.insert(index, product);
      notifyListeners();
      throw HttpException("Error");
    }
    product = null;
  }
}
