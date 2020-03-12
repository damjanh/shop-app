import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                _showOnlyFavorites = FilterOptions.Favorites == selected;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                checked: !_showOnlyFavorites,
                child: Text('All'),
                value: FilterOptions.All,
              ),
              CheckedPopupMenuItem(
                checked: _showOnlyFavorites,
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
