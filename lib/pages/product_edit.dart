import 'dart:io';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_inputs/location.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';
import '../models/location_data.dart';
import '../widgets/form_inputs/image.dart';

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
    'image': null,
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Product product) {
    if (product == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (product != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = product.title;
    } else if (product != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (product == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }

    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Product Title'),
          controller: _titleTextController,
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
    if (product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }

    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product Description'),
          maxLines: 4,
          controller: _descriptionTextController,
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
    if (product == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (product != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = product.price.toString();
    }

    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
            focusNode: _priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            controller: _priceTextController,
            validator: (String value) {
              if (value.isEmpty ||
                  !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
                return 'Price is required and should be a number';
              }
            }));
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
                    ImageInput(_setImage, product),
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

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(Function addProduct, Function updateProduct,
      int selectedProductIndex, Function setSelectedProduct) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }

    _formKey.currentState.save();

    if (selectedProductIndex == -1) {
      addProduct(
              _titleTextController.text,
              _descriptionTextController.text,
              _formData['image'],
              double.parse(
                  _priceTextController.text.replaceFirst(RegExp(r','), '.')),
              _formData['location'])
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
      updateProduct(
              _titleTextController.text,
              _descriptionTextController.text,
              _formData['image'],
              double.parse(
                  _priceTextController.text.replaceFirst(RegExp(r','), '.')),
              _formData['location'])
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
