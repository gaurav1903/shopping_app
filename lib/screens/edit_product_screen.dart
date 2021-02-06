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
  void initState() {
    imageurlfocusnode.addListener(() => updateimageurl);
    super.initState();
  }

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

  @override
  void dispose() {
    imageurlfocusnode.removeListener(updateimageurl);
    pricefocusnode.dispose();
    descriptfocusnode.dispose;
    imageurlcontroller.dispose();
    super.dispose();
  }

  var _isinit = true;
  var _isloading = false;

  void updateimageurl() {
    if (!imageurlfocusnode.hasFocus) {
      if ((!imageurlcontroller.text.startsWith('http') &&
              !imageurlcontroller.text.startsWith('https')) ||
          (!imageurlcontroller.text.endsWith('.png') &&
              !imageurlcontroller.text.endsWith('.jpg') &&
              !imageurlcontroller.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveform() async {
    print('status 3');
    _form.currentState.save();
    print('status 2');
    if (_editedproduct.id != null) {
      setState(() {
        _isloading = true;
      });
      await Provider.of<ProductData>(context, listen: false)
          .updateproduct(_editedproduct.id, _editedproduct);
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      print('status 1');
      setState(() {
        _isloading = true;
      });
      try {
        await Provider.of<ProductData>(context, listen: false)
            .addProduct(_editedproduct);
        setState(() {
          print('status future recieved');
          _isloading = false;
        });
      } catch (error) {
        print('error recieved');
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error Ocurred'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Close'),
                  )
                ],
              );
            });
      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print('status 4');
              return saveform();
            },
          )
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                            id: _editedproduct.id,
                            price: _editedproduct.price,
                            description: _editedproduct.description,
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
                            id: _editedproduct.id,
                            price: double.parse(value),
                            description: _editedproduct.description,
                            isFavourite: _editedproduct.isFavourite,
                            imageurl: _editedproduct.imageurl);
                      },
                      validator: (val) {
                        if (val.isEmpty) return 'please enter a value';
                        if (double.tryParse(val) == null)
                          return 'invald number';
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
                            id: _editedproduct.id,
                            isFavourite: _editedproduct.isFavourite,
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
                                imageurl: value,
                                id: _editedproduct.id,
                              );
                              print('status 5');
                            },
                            validator: (val) {
                              if (val.isEmpty) return 'cannot be left empty';
                              if (!val.startsWith('http') &&
                                  (!val.startsWith('https')))
                                return 'invalid url';
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
