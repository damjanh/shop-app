import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get products {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-app-3aaff.firebaseio.com/products.json';
    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> products = [];
    data.forEach((key, value) {
      products.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: value['isFavorite'],
          imageUrl: value['imageUrl']));
    });
    _items = products;
    notifyListeners();
  }

  Future<void> addProduct(Product value) async {
    const url = 'https://shop-app-3aaff.firebaseio.com/products.json';
    var response = await http.post(url,
        body: json.encode({
          'title': value.title,
          'description': value.description,
          'imageUrl': value.imageUrl,
          'price': value.price,
          'isFavorite': value.isFavorite
        }));

    final newProduct = Product(
        title: value.title,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
        id: json.decode(response.body)['name']);
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://shop-app-3aaff.firebaseio.com/products/$id.json';
    await http.patch(url, body: json.encode({
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price
    }));
    final index = _items.indexWhere((element) => element.id == id);
    _items[index] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
