import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
      body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
