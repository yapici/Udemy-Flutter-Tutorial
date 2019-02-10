import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage({this.addProduct, this.updateProduct, this.product, this.productIndex});

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
    'image': 'assets/food.jpeg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: widget.product == null ? '' : widget.product['title'],
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
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 4,
      initialValue: widget.product == null ? '' : widget.product['description'],
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (widget.product == null) {
      widget.addProduct(_formData);
    } else {
      widget.updateProduct(widget.productIndex, _formData);
    }

    Navigator.pushReplacementNamed(context, "/products");
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
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
                    _buildTitleTextField(),
                    _buildDescriptionTextField(),
                    _buildPriceTextField(),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      child: Text('Save'),
                      textColor: Colors.white,
                      onPressed: _submitForm,
                    )
//            GestureDetector(
//                onTap: _submitForm,
//                child: Container(
//                    color: Colors.green,
//                    padding: EdgeInsets.all(10.0),
//                    child: Text('My Button')))
                  ],
                ))));

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(title: Text('Edit Product')), body: pageContent);
  }
}
