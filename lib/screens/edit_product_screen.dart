import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import 'package:shopapp/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // get the focusNode (1).
  final _imageFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageTextEditingController = TextEditingController();
  final _key = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  var _didChangeValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isDidChange = true;
  var _isLoading = false;

  @override
  void initState() {
    // i cant understand this bus use this (4).
    _imageFocusNode.addListener(_changeImageBoxStatus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isDidChange) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _didChangeValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageTextEditingController.text = _editedProduct.imageUrl;
      }
    }
    _isDidChange = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // dispose Listener (5).
    _imageFocusNode.removeListener(_changeImageBoxStatus);
    // dispose focusNode (3).
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageTextEditingController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _changeImageBoxStatus() {
    // check that tis is in focus or not (6).
    if (!_imageFocusNode.hasFocus) {
//      if ((!_imageTextEditingController.text.startsWith('http') &&
//              !_imageTextEditingController.text.startsWith('https')) ||
//          (!_imageTextEditingController.text.endsWith('.png') &&
//              !_imageTextEditingController.text.endsWith('.jpg') &&
//              !_imageTextEditingController.text.endsWith('.jpeg'))) {
//        return;
//      }
      setState(() {});
    }
  }

  Future<void> _onSave() async {
    final checkVelidation = _key.currentState.validate();
    if (!checkVelidation) {
      return;
    }
    _key.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Somthing Went Wrong!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK')),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

//  void _onSave() {
//    final checkVelidation = _key.currentState.validate();
//    if (!checkVelidation) {
//      return;
//    }
//    _key.currentState.save();
//    setState(() {
//      _isLoading = true;
//    });
//    if (_editedProduct.id != null) {
//      Provider.of<Products>(context, listen: false)
//          .updateProduct(_editedProduct.id, _editedProduct);
//      setState(() {
//        _isLoading = false;
//      });
//      Navigator.of(context).pop();
//    } else {
//      Provider.of<Products>(context, listen: false)
//          .addProduct(_editedProduct)
//          .catchError((error) {
//        return showDialog<Null>(
//          context: context,
//          builder: (ctx) => AlertDialog(
//            title: Text('Error'),
//            content: Text('Somthing Went Wrong!'),
//            actions: <Widget>[
//              FlatButton(
//                  onPressed: () {
//                    Navigator.of(ctx).pop();
//                  },
//                  child: Text('OK')),
//            ],
//          ),
//        );
//      }).then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.of(context).pop();
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _onSave),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _didChangeValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _didChangeValue['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter Valid Price.';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'PLease Enter a Greater Price then zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _didChangeValue['description'],
                        decoration: InputDecoration(labelText: 'Discreption'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Discreption';
                          }
                          if (value.length < 10) {
                            return 'Should be atleast 10 charcter.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 100.0,
                            margin: EdgeInsets.only(
                              top: 8.0,
                              left: 10.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageTextEditingController.text.isEmpty
                                ? Text('Enter URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageTextEditingController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'ImageURL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageTextEditingController,
                              // this is use for information of focus(2).
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                _onSave();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter ImageURL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please Enter a Valid Url';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please Enter a Valid image Format';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
