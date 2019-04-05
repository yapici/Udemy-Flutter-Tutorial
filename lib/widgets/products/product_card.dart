import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(
              width: 8.0,
            ),
            PriceTag(product.price.toString())
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          iconSize: 24.0,
          onPressed: () {
            model.selectProduct(model.allProducts[productIndex].id);
            Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[productIndex].id)
                .then((_) => model.selectProduct(null));
          },
        ),
        IconButton(
          icon: Icon(model.allProducts[productIndex].isFavorite == true
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
          iconSize: 24.0,
          onPressed: () {
            model.selectProduct(model.allProducts[productIndex].id);
            model.toggleProductFavoriteStatus();
          },
        )
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/food.jpeg'),
          ),
          _buildTitlePriceRow(),
          AddressTag(product.location.address),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
