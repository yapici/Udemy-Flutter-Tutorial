import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_inputs/location.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';
import '../models/location_data.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpeg',
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Product Title'),
          initialValue: product == null ? '' : product.title,
//      autovalidate: true,
          validator: (String value) {
//        if (value.trim().length <= 0) {
//          return 'Title is required';
//        }

            if (value.isEmpty || value.length < 5) {
              return 'Title is required and should be 5+ characters long';
            }
          },
          onSaved: (String value) {
            _formData['title'] = value;
          },
        ));
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product Description'),
          maxLines: 4,
          initialValue: product == null ? '' : product.description,
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return 'Description is required and should be 10+ characters long';
            }
          },
          onSaved: (String value) {
            _formData['description'] = value;
          },
        ));
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          focusNode: _priceFocusNode,
          decoration: InputDecoration(labelText: 'Product Price'),
          keyboardType: TextInputType.number,
          initialValue: product == null ? '' : product.price.toString(),
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
              return 'Price is required and should be a number';
            }
          },
          onSaved: (String value) {
            _formData['price'] = double.parse(value);
          },
        ));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectedProductIndex,
                  model.selectProduct),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .requestFocus(FocusNode()); // Removing focus from inputs
        },
        child: Container(
            width: targetWidth,
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    _buildTitleTextField(product),
                    _buildDescriptionTextField(product),
                    _buildPriceTextField(product),
                    SizedBox(height: 10.0),
                    LocationInput(_setLocation, product),
                    SizedBox(height: 10.0),
                    _buildSubmitButton()
//            GestureDetector(
//                onTap: _submitForm,
//                child: Container(
//                    color: Colors.green,
//                    padding: EdgeInsets.all(10.0),
//                    child: Text('My Button')))
                  ],
                ))));
  }

  void _setLocation(LocationData locationData) {
    _formData['location'] = locationData;
  }

  void _submitForm(Function addProduct, Function updateProduct,
      int selectedProductIndex, Function setSelectedProduct) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (selectedProductIndex == -1) {
      addProduct(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'], _formData['location'])
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, "/products")
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Something went wrong'),
                    content: Text('Please try again later'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop())
                    ]);
              });
        }
      });
    } else {
      updateProduct(_formData['title'], _formData['description'],
              _formData['image'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, "/products")
              .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);

      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(title: Text('Edit Product')), body: pageContent);
    });
  }
}
