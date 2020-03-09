import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
