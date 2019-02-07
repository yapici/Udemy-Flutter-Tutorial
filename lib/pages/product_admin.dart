import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class ProductAdmin extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  ProductAdmin(this.addProduct, this.deleteProduct);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Choose'),
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Products'),
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              text: 'Create Product',
              icon: Icon(Icons.add),
            ),
            Tab(
              text: 'My Products',
              icon: Icon(Icons.list),
            )
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductCreatePage(addProduct),
            ProductListPage()
          ],
        ),
      ),
    );
  }
}
