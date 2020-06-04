import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import '../models/cart_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final String dateTime;

  Order(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-app-3aaff.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(
        Order(
          id: key,
          amount: value['amount'],
          dateTime: value['dateTime'],
          products: (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-3aaff.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now().toIso8601String();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList()
          }));

      _orders.insert(
          0,
          Order(
              id: json.decode(response.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartProducts));
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not add order!');
    }
  }
}
