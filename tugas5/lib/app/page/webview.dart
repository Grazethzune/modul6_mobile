import 'package:flutter/material.dart';
import 'package:tugas_1/app/data/models/product.dart';
import 'package:tugas_1/app/modules/home/controllers/webview_controller.dart';
import 'package:tugas_1/app/page/third.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductWebViewScreen extends StatefulWidget {
  final String url;
  // URL produk yang akan dibuka dalam WebView

  ProductWebViewScreen({required this.url}); // Konstruktor untuk menerima URL

  @override
  _ProductWebViewScreenState createState() => _ProductWebViewScreenState();
}

class _ProductWebViewScreenState extends State<ProductWebViewScreen> {
  bool isLoading = true; // Menampilkan loading saat halaman dimuat
  WebviewController controller = WebviewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller
                .webViewController('https://en.wikipedia.org/wiki/Main_Page'),
          ),
        ],
      ),
    );
  }
}
