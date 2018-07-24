import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/food.jpeg'),
          Text(products[index])
        ],
      ),
    );
  }

  Widget _buildProductList() {

    Widget productCards;

//    Widget productCards = Center(
//      child: Text('No products found, please add some'),
//    );

    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }

    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
