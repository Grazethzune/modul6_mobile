import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas_1/app/page/landing_page.dart';
import 'package:tugas_1/app/page/no_connection_view.dart';
import 'package:tugas_1/app/page/third.dart';

class ConnectionController extends GetxController {
  final _storage = GetStorage();
  final Connectivity _connectivity = Connectivity();
  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
// Jika connectivityResults adalah List<ConnectivityResult>, kita ambil hasil pertama
      _updateConnectionStatus(connectivityResults.first);
      if (connectivityResults.first != ConnectivityResult.none) {
        _retryUpload(); // Coba upload saat koneksi terhubung
      }
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar('Jaringan tidak tersedia', 'Memasuki mode offline');
      if (Get.currentRoute == '/ProductListLainnyaScreen') {
        Get.off(() => const NoConnectionView());
      }
    } else {
      Get.snackbar('Jaringan telah tersedia', 'Memasuki mode online');
      if (Get.currentRoute == '/NoConnectionView' &&
          Get.previousRoute == '/ProductListLainnyaScreen') {
        Get.off(() => ProductListLainnyaScreen());
      }
    }
  }

  Future<void> saveToLocal(Map<String, dynamic> data) async {
    List<dynamic> offlineData =
        _storage.read<List<dynamic>>('offlineData') ?? [];
    offlineData.add(data);
    await _storage.write('offlineData', offlineData);
    Get.snackbar('Offline', 'Data disimpan ke penyimpanan lokal.');
  }

  // Fungsi untuk mencoba mengupload semua data lokal ke database
  Future<void> _retryUpload() async {
    List<dynamic> offlineData =
        _storage.read<List<dynamic>>('offlineData') ?? [];

    if (offlineData.isNotEmpty) {
      try {
        // Upload semua data secara paralel
        await Future.wait(offlineData.map((data) async {
          await FirebaseFirestore.instance.collection('cart').add(data);
        }));

        // Jika berhasil, hapus semua data lokal
        await _storage.remove('offlineData');
        Get.snackbar('Success', 'Semua data berhasil diunggah.');
      } catch (e) {
        Get.snackbar('Error', 'Gagal mengunggah data: $e');
      }
    }
  }

  // Fungsi untuk mengupload data ke Firestore
  Future<void> uploadData(Map<String, dynamic> data) async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.first == ConnectivityResult.none) {
      print('No internet connection. Saving to local storage...');
      await saveToLocal(data);
    } else {
      try {
        await FirebaseFirestore.instance.collection('cart').add(data);
        Get.snackbar('Success', 'Data berhasil diunggah.');
      } catch (e) {
        print('Error uploading data: $e');
        await saveToLocal(data);
      }
    }
  }
}
