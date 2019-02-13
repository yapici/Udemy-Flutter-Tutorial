import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../models/product.dart';

class ProductAdmin extends StatelessWidget {
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
          onTap: () => Navigator.pushReplacementNamed(context, '/products'),
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
            ProductEditPage(),
            ProductListPage(null, null, null)
          ],
        ),
      ),
    );
  }
}
