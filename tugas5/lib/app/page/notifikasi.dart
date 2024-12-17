import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeNotification();
  }

  void _initializeNotification() async {
    // Permintaan izin notifikasi untuk iOS
    await _firebaseMessaging.requestPermission();

    // Untuk menangani notifikasi saat aplikasi berada di kondisi Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Untuk menangani notifikasi saat aplikasi berada di kondisi Background atau Terterminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message);
      _handleMessage(message);
    });

    // Menangani notifikasi jika aplikasi dimulai dari keadaan Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    Get.snackbar(
      title ?? 'Notifikasi',
      body ?? 'Ada notifikasi baru',
      snackPosition: SnackPosition.TOP,
    );
  }
}
