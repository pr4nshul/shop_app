import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/product.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      description: null, title: null, id: null, price: null, imageUrl: null);
  var initValues = {
    'title' :'',
    'description' : '',
    'price' : '',
  };
  var init = true;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(init){
      final productId =ModalRoute.of(context).settings.arguments as String;
      final product = Provider.of<ProductProvider>(context).findById(productId);
      _editedProduct = product;
      initValues['title'] = product.title;
      initValues['description'] = product.description;
      initValues['price'] = product.price.toString();
      _imageUrlController.text = product.imageUrl;
    }
    init =false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if ((!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg') &&
            !_imageUrlController.text.endsWith('.png'))) {
      return;
    }
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() {
    final check = _form.currentState.validate();
    if (!check) {
      return;
    }
    _form.currentState.save();
    if(_editedProduct.id == null){
    Provider.of<ProductProvider>(context,listen: false).addItem(_editedProduct);
    }else{
      Provider.of<ProductProvider>(context,listen: false).updateItem(_editedProduct.id, _editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    description: _editedProduct.description,
                    title: value,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFav: _editedProduct.isFav,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Enter a price greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    description: _editedProduct.description,
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    isFav: _editedProduct.isFav,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length <= 10) {
                    return 'Description is too short';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    description: value,
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFav: _editedProduct.isFav,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Enter a Url'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a URL";
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.png')) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          price: _editedProduct.price,
                          imageUrl: value,
                          isFav: _editedProduct.isFav,
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
    );
  }
}
