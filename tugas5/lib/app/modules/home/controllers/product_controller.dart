import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_1/app/data/models/product.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductController extends GetxController {
  late Future<List<Product>> products;
  @override
  void onInit() async {
    super.onInit();
    products = fetchProducts();
  }

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
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
}
