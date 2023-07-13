import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_project/screens/product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://dummyjson.com/products');
    final response = await http.get(url);

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   if (data is List<dynamic>) {
    //     setState(() {
    //       productList = data;
    //     });
    //   } else {
    //     Fluttertoast.showToast(
    //       msg: 'Invalid response format',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //     );
    //   }
    // } else {
    //   Fluttertoast.showToast(
    //     msg: 'Failed to fetch data',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //   );
    // }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        productList = data['products'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        product['images'][0],
                      ),
                    ),
                  ),
                ),
                title: Text(product['title']),
                subtitle: Text(product['description']),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductPage(product)),
                    );
                  },
                  child: Text('Edit'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
