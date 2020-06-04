import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;

  ProductsProvider(this.authToken, this._items);

  List<Product> _items = [];

  List<Product> get products {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = 'https://shop-app-3aaff.firebaseio.com/products.json?auth=$authToken';
    final response = await http.get(url);
    final data = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> products = [];
    if (data == null) {
      return;
    }
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
    final url = 'https://shop-app-3aaff.firebaseio.com/products.json?auth=$authToken';
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
    final url = 'https://shop-app-3aaff.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));
    final index = _items.indexWhere((element) => element.id == id);
    _items[index] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-app-3aaff.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode <= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
