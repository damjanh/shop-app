import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final orderItem = ordersProvider.orders[index];
          return Text(orderItem.id);
        },
        itemCount: ordersProvider.orders.length,
      ),
    );
  }
}
