import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product_data.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final pricefocusnode = FocusNode();
  final imageurlcontroller = TextEditingController();
  final descriptfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  final imageurlfocusnode = FocusNode();
  var _editedproduct =
      Product(id: null, title: '', price: 0, imageurl: '', description: '');
  var _initvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': ''
  };
  @override
  void dispose() {
    pricefocusnode.dispose();
    descriptfocusnode.dispose();
    imageurlcontroller.dispose();
    imageurlfocusnode.dispose();
    imageurlfocusnode.removeListener(() {
      return updateimageurl;
    });
    super.dispose();
  }

  @override
  void initState() {
    imageurlfocusnode.addListener(() => updateimageurl);
    super.initState();
  }

  var _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productid = ModalRoute.of(context).settings.arguments;
      if (productid != null) {
        final _editedproduct = Provider.of<ProductData>(context, listen: false)
            .findbyid(productid);
        _initvalues = {
          'title': _editedproduct.title,
          'description': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          'imageurl': '',
        };
        imageurlcontroller.text = _editedproduct.imageurl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void updateimageurl() {
    if (!imageurlfocusnode.hasFocus) {
      setState(() {});
    }
  }

  void saveform() {
    _form.currentState.save();
    if (_editedproduct.id != null) {
      Provider.of<ProductData>(context, listen: false)
          .updateproduct(_editedproduct.id, _editedproduct);
    } else
      Provider.of<ProductData>(context, listen: false)
          .addProduct(_editedproduct);
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveform,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initvalues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(pricefocusnode);
                },
                onSaved: (value) {
                  _editedproduct = Product(
                      title: value,
                      price: _editedproduct.price,
                      description: _editedproduct.description,
                      id: _editedproduct.id,
                      isFavourite: _editedproduct.isFavourite,
                      imageurl: _editedproduct.imageurl);
                },
                validator: (val) {
                  if (val.isEmpty)
                    return 'Enter a Title';
                  else
                    return null;
                },
              ),
              TextFormField(
                initialValue: _initvalues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: pricefocusnode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptfocusnode);
                },
                onSaved: (value) {
                  _editedproduct = Product(
                      title: _editedproduct.title,
                      price: double.parse(value),
                      description: _editedproduct.description,
                      id: _editedproduct.id,
                      isFavourite: _editedproduct.isFavourite,
                      imageurl: _editedproduct.imageurl);
                },
                validator: (val) {
                  if (val.isEmpty) return 'please enter a value';
                  if (double.tryParse(val) == null) return 'invald number';
                  if (double.parse(val) <= 0)
                    return 'invalid';
                  else
                    return null;
                },
              ),
              TextFormField(
                initialValue: _initvalues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: descriptfocusnode,
                onSaved: (value) {
                  _editedproduct = Product(
                      title: _editedproduct.title,
                      price: _editedproduct.price,
                      description: value,
                      isFavourite: _editedproduct.isFavourite,
                      id: _editedproduct.id,
                      imageurl: _editedproduct.imageurl);
                },
                validator: (val) {
                  if (val.isEmpty) return 'enter a description';
                  if (val.length <= 10) return 'write in detail';
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: imageurlcontroller.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              imageurlcontroller.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'ImageURL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageurlcontroller,
                      focusNode: imageurlfocusnode,
                      onFieldSubmitted: (_) => saveform,
                      onSaved: (value) {
                        _editedproduct = Product(
                          title: _editedproduct.title,
                          isFavourite: _editedproduct.isFavourite,
                          price: _editedproduct.price,
                          description: _editedproduct.description,
                          id: _editedproduct.id,
                          imageurl: value,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) return 'cannot be left empty';
                        if (!val.startsWith('http') &&
                            (!val.startsWith('https'))) return 'invalid url';
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
