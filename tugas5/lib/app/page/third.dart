import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tugas_1/app/page/no_connection_view.dart';
import 'package:tugas_1/app/page/webview.dart';

class ProductListLainnyaScreen extends StatefulWidget {
  @override
  _ProductListLainnyaScreenState createState() =>
      _ProductListLainnyaScreenState();
}

class _ProductListLainnyaScreenState extends State<ProductListLainnyaScreen> {
  late Future<List<Product>> products;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkConnection(); // Periksa koneksi saat inisialisasi
    products = fetchProducts();
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      // Jika tidak ada koneksi, arahkan ke NoConnectionView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoConnectionView()),
      );
    }
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // Filter products to include only men's and women's clothing
      return jsonResponse
          .map((product) => Product.fromJson(product))
          .where((product) =>
              product.category == "men's clothing" ||
              product.category == "women's clothing")
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Seller Lainnya'),
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> productList = snapshot.data!;

            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductWebViewScreen(
                          url:
                              'https://fakestoreapi.com/products', // Ambil URL produk yang benar
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Image.network(
                            productList[index].image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productList[index].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(productList[index].description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 5),
                                Text(
                                    'Price: \$${productList[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.green)),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.yellow, size: 16),
                                    Text('${productList[index].rating}',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Product {
  final String title;
  final String description;
  final String image;
  final double rating;
  final double price;
  final String category;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double),
      rating: json['rating']['rate'].toDouble(),
      category: json['category'],
    );
  }
}
