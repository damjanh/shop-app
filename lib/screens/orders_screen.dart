import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';

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
          return OrderItem(order: orderItem);
        },
        itemCount: ordersProvider.orders.length,
      ),
    );
  }
}
