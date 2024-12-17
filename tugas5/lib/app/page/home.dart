import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_1/app/modules/home/controllers/VIDEO/videocontoller.dart';
import 'package:tugas_1/app/modules/home/controllers/home_controller.dart';
import 'package:tugas_1/app/page/image_picker.dart';
import 'package:tugas_1/app/page/detail_product.dart';
import 'package:tugas_1/app/page/third.dart';
import 'package:video_player/video_player.dart';

import '../modules/home/controllers/VIDEO/videoview.dart';
import '../modules/home/controllers/suara/voice_controller.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());

  // Initialize Firebase and local notifications
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Request notification permissions and initialize local notifications
    _requestPermissions();
    _initializeLocalNotifications();

    // Show welcome notification
    _showWelcomeNotification();
  }

  void _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotification.initialize(initSettings);
  }

  void _showWelcomeNotification() {
    const androidDetails = AndroidNotificationDetails(
      'welcome_channel',
      'Welcome Notifications',
      channelDescription: 'This channel is used for welcome notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show welcome notification
    _localNotification.show(
      0,
      'Welcome!',
      'Welcome to the Home Page!',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
          ),
          InkWell(
            onTap: () => Get.to(ImagePickerPage()),
            child: Obx(
              () => controller.selectedImagePath.value == ''
                  ? CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.white),
                    )
                  : CircleAvatar(
                      backgroundImage:
                          FileImage(File(controller.selectedImagePath.value)),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHotDealBanner(),
            _buildFlashSaleSection(),
            _buildTopSellerSection(),
          ],
        ),
      ),
    );
  }

 Widget _buildSearchBar() {
    final VoiceController soundController = Get.put(VoiceController());
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() => TextField(
          onChanged: (value) => homeController.searchProduct(value),
          decoration: InputDecoration(
            hintText: 'Search Product',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                soundController.isListening.value ? Icons.mic : Icons.mic_none,
                color: soundController.isListening.value ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                if (soundController.isListening.value) {
                  soundController.stopListening();
                } else {
                  soundController.startListening();
                }
              },
            ),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ));
  }

 Widget _buildProductList() {
  final HomeController homeController = Get.find<HomeController>();

  return Obx(() {
    // Ensure products list is not null or empty
    if (homeController.products.isEmpty) {
      return Center(child: Text('No products available.'));
    }

    return ListView.builder(
      itemCount: homeController.products.length,
      itemBuilder: (context, index) {
        final product = homeController.products[index];
        
        // Ensure that the product has the necessary fields
        String imagePath = product['image'] ?? ''; // Default to empty string if not found
        String name = product['name'] ?? 'Unnamed Product';
        String price = product['price'] ?? '0';

        return ListTile(
          leading: imagePath.isNotEmpty
              ? Image.asset(imagePath)
              : Icon(Icons.image, color: Colors.grey), // Fallback to icon if image is missing
          title: Text(name),
          subtitle: Text('Price: $price'),
        );
      },
    );
  });
}



Widget _buildHotDealBanner() {
  final VideoController videoController = Get.put(VideoController());

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (videoController.selectedVideoPath.value.isEmpty) {
            return GestureDetector(
              onTap: () => _showVideoUploadOptions(videoController),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Tap to Upload Video Ads',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _showVideoUploadOptions(videoController),
              child: AspectRatio(
                aspectRatio: videoController.videoPlayerController?.value.aspectRatio ?? 16 / 9,
                child: VideoPlayer(videoController.videoPlayerController!),
              ),
            );
          }
        }),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _showVideoUploadOptions(videoController),
          icon: Icon(Icons.upload_file),
          label: Text('Upload New Video'),
        ),
      ],
    ),
  );
}

void _showVideoUploadOptions(VideoController videoController) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Video Source',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Pick from Gallery'),
            onTap: () {
              videoController.pickOrRecordVideo(ImageSource.gallery);
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Record Video'),
            onTap: () {
              videoController.pickOrRecordVideo(ImageSource.camera);
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}


  Widget _buildFlashSaleSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flash Sale',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Obx(() => Text(controller.flashSaleTime.value)),
          SizedBox(height: 10),
          _buildAutoScrollingProductList(),
        ],
      ),
    );
  }

  Widget _buildAutoScrollingProductList() {
    return Obx(() => Container(
          height: 250, // Set height for the horizontal list
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              var product = controller.products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildHorizontalProductCard(product),
              );
            },
          ),
        ));
  }

  Widget _buildHorizontalProductCard(Map<String, String> product) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductPage and pass product details
        Get.to(ProductPage(
          isEdit: false,
          name: product['name']!,
          price: product['price']!,
          discount: product['discount']!,
          originalPrice: product['originalPrice']!,
          location: product['location']!,
          index_color: product['index_color']!,
          index_size: product['index_size']!,
          image_path: product['image']!,
        ));
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 209, 209, 209),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 203, 37, 37).withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                product['image']!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product['name']!, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Rp. ${product['price']!}',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Rp. ${product['originalPrice']!}',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${product['discount']!} %',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product['location']!,
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList() {
    return Obx(() => Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              var product = controller.products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _buildHorizontalProductCard(product),
              );
            },
          ),
        ));
  }

  Widget _buildTopSellerSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Seller',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () => Get.to(ProductListLainnyaScreen()),
                  icon: Icon(Icons.arrow_right_alt, color: Colors.black)),
            ],
          ),
          SizedBox(height: 10),
          _buildHorizontalProductList(),
        ],
      ),
    );
  }
}
