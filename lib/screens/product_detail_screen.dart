import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title),
            background: Hero(
              tag: productId,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 800,
            )
          ]),
        ),
      ],
    ));
  }
}
