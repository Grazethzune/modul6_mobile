import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isAuthenticated = false.obs;

  // State for navigation
  final tabIndex = 0.obs;
  var index = 0.obs;

  // Timer and PageController for auto-scrolling banners
  Timer? timer;
  late PageController pageController;
  int currentPage = 0;

  // State for image picker
  var selectedImagePath = "".obs;
  var selectedImageSize = "".obs;

  // Flash sale time
  var flashSaleTime = '02:08:10'.obs;

  // List of products
  var products = [
    {
      'name': 'Teripang Belitung',
      'price': '50000', // Convert to String
      'discount': '50', // Convert to String
      'originalPrice': '100000', // Convert to String
      'location': 'Jakarta',
      'index_color': '0',
      'index_size': '0',
      'image': 'assets/images/Frame 2.png' // Example image
    },
    {
      'name': 'Sepatu Puma',
      'price': '300000', // Convert to String
      'discount': '10', // Convert to String
      'originalPrice': '330000', // Convert to String
      'location': 'Jakarta',
      'index_color': '0',
      'index_size': '0',
      'image': 'assets/images/Frame 2.png' // Example image
    },
    {
      'name': 'Sepatu Adidas',
      'price': '500000', // Convert to String
      'discount': '10', // Convert to String
      'originalPrice': '400000', // Convert to String
      'location': 'Surabaya',
      'index_color': '0',
      'index_size': '0',
      'image': 'assets/images/Frame 2.png' // Example image
    }
  ].obs;

  // Image Picker
  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value =
          ((File(selectedImagePath.value)).lengthSync() / 1024 / 1024)
                  .toStringAsFixed(2) +
              "MB";
    } else {
      Get.snackbar('Error', 'Image Not Selected');
    }
  }

  // Change tab index
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
        initialPage: 0, viewportFraction: 0.8); // Create PageController
    loadInitialProducts();
    startAutoScroll();
    fetchCartItems();
  }

  @override
  void onClose() {
    timer?.cancel(); // Cancel timer when the controller is closed
    pageController.dispose();
    super.onClose();
  }

  // Load initial products
  void loadInitialProducts() {
    products.addAll([
      {
        'name': 'Teripang Belitung',
        'price': '50.000',
        'discount': '50',
        'originalPrice': '100.000',
        'location': 'Jakarta',
        'index_color': '0',
        'index_size': '0',
        'image': 'assets/images/Frame 2.png'
      },
      {
        'name': 'Sepatu Puma',
        'price': '300.000',
        'discount': '10',
        'originalPrice': '330.000',
        'location': 'Malang',
        'index_color': '0',
        'index_size': '0',
        'image': 'assets/images/Frame 2.png'
      }
    ]);
  }

  // Auto-scroll for product banners
  void startAutoScroll() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (currentPage < products.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void increment() => index.value++;

  @override
  void dispose() {
    super.dispose();
  }

  // Firestore database
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable list of cart items
  var cartItems = <Map<String, dynamic>>[].obs;

  // Add item to cart
  Future<void> addItemToCart(
      String name,
      String discount,
      String price,
      String originPrice,
      String location,
      String index_color,
      String index_size,
      String image_path) async {
    try {
      await firestore.collection('cart').add({
        'name': name,
        'price': price,
        'discount': discount,
        'originalPrice': originPrice,
        'location': location,
        'image': image_path,
        'color': index_color,
        'size': index_size,
        'Date': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Item added to cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item to cart: $e');
    }
  }

  // Fetch cart items from Firestore
  Future<void> fetchCartItems() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('cart').get();
      cartItems.value = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // Add the document ID to the data
        return data;
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cart items: $e');
    }
  }

  // Logout
  void logout() {
    _auth.signOut();
    isAuthenticated.value = false;
    Get.offAllNamed('/login'); // Notifikasi logout
  }

  // Search products
  void searchProduct(String query) {
    // Filter produk berdasarkan nama
    var result = products
        .where((product) =>
            product['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    products.value = result; // Update produk yang ditampilkan
  }

  // Handle image loading state
  var isImageLoading = false.obs;

  void pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true; // Aktifkan status pemuatan
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      } else {
        Get.snackbar('Error', 'No image selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    } finally {
      isImageLoading.value = false; // Nonaktifkan status pemuatan
    }
  }
}
