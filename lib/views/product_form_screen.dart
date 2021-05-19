import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void updateImageUrl() {
    if (_isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool _isValidImageUrl(String url) {
    final startWithHttp = url.toLowerCase().startsWith('http://');
    final startWithHttps = url.toLowerCase().startsWith('https://');
    final endsWithPng = url.toLowerCase().endsWith('.png');
    final endsWithJpg = url.toLowerCase().endsWith('.jpg');
    final endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  void _saveForm() {
    bool isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    final newProduct = Product(
      id: Random().nextDouble().toString(),
      title: _formData['title'].toString(),
      description: _formData['description'].toString(),
      price: double.parse(_formData['price'].toString()),
      imageUrl: _formData['imageUrl'].toString(),
    );

    print(newProduct.id);
    print(newProduct.title);
    print(newProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar produto"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                decoration: InputDecoration(
                  labelText: "Título",
                ),
                onSaved: (value) {
                  _formData['title'] = value!;
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'O campo não pode estar vazio!';
                  }
                },
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  labelText: "Preço",
                ),
                onSaved: (value) {
                  _formData['price'] = double.parse(value!);
                },
                validator: (value) {
                  final bool isEmpty = value!.trim().isEmpty;
                  final double? newPrice = double.tryParse(value);
                  final bool isInvalid = newPrice == null || newPrice <= 0;

                  if (isEmpty || isInvalid) {
                    return 'Informe um preço válido!';
                  }
                },
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                decoration: InputDecoration(
                  labelText: "Descrição",
                ),
                onSaved: (value) {
                  _formData['description'] = value!;
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'O campo não pode estar vazio!';
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: "URL da Imagem",
                      ),
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _formData['imageUrl'] = value!;
                      },
                      validator: (value) {
                        final bool isEmpty = value!.trim().isEmpty;
                        final bool isInvalid = _isValidImageUrl(value);

                        if (isEmpty || isInvalid) {
                          return 'Informe uma URL válida!';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      left: 5,
                    ),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text("Informe uma URL")
                        : FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.fitWidth,
                            ),
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
