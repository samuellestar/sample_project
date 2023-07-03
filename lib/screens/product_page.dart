import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final dynamic product;

  const ProductPage(this.product, {super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? product =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (product != null) {
        _titleController.text = product['title'];
        _priceController.text = product['price'].toString();
        _thumbnailController.text = product['thumbnail'];
        _descriptionController.text = product['description'];
      }
    });
  }

  Future<void> updateProduct(Map<String, dynamic> product) async {
    final url = 'https://dummyjson.com/products/1';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(product);

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully')),
      );
      Navigator.pop(context, product);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(
            //   height: 40,
            // ),

            // Image.network(product['image']),

            Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.product['images'][0])),
              ),
            ),

            // Text(
            //   'Thumbnail: ${product['thumbnail']}\n',
            //   textAlign: TextAlign.center,
            // ),
            Text(
              '${widget.product['title']}\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Price: ${widget.product['price']}\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Brand: ${widget.product['brand']}\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Rating:${widget.product['rating']}\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Disount: ${widget.product['discountPercentage']}\n',
              textAlign: TextAlign.center,
            ),

            Text(
              'Description: ${widget.product['description']}\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Stock: ${widget.product['stock']}\n',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Update',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _thumbnailController,
                    decoration: InputDecoration(labelText: 'Thumbnail URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a thumbnail URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedProduct = {
                          'title': _titleController.text,
                          'price': int.parse(_priceController.text),
                          'thumbnail': _thumbnailController.text,
                          'description': _descriptionController.text,
                        };
                        updateProduct(updatedProduct);
                      }
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
