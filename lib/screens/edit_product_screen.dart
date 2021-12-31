import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/lib/screens/edit_product_screen.dart';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
      isFavorite: false);

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  var _initValue = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
    // 'isFavorite': false
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
          .findById(productId);

      _initValue = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'imageUrl': '',
        'price': _editedProduct.price.toString(),
        // 'isFavorite': false
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValue['title'],
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Provide a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: value!,
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite,
                      price: _editedProduct.price);
                },
              ),
              TextFormField(
                initialValue: _initValue['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "provide a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "please Provide a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                    price: double.parse(value!),
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['description'],
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value!,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Provide a value";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 0,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValue['imageUrl'],
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          imageUrl: value!,
                          isFavorite: _editedProduct.isFavorite,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please Provide a value";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
