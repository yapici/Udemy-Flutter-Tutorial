import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards;

//    Widget productCards = Center(
//      child: Text('No products found, please add some'),
//    );

    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index]),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }

    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
