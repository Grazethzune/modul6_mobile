import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tugas_1/app/modules/home/controllers/home_controller.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool showQRIS = false;

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        showQRIS = false;
      });
    }
  }

  void _navigateToQRIS() {
    setState(() {
      showQRIS = true;
    });
  }

  void _navigateToScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerPage()),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeController landingPageController = Get.find<HomeController>();
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA52A2A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            landingPageController.changeTabIndex(0); // Kembali ke halaman Home
          },
        ),
        title: Text(
          'BAYAR',
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255), fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentOption(
                        'assets/images/visa.png', 'Visa', deviceWidth, deviceHeight),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentOption(
                        'assets/images/bca.png', 'BCA', deviceWidth, deviceHeight),
                    _buildPaymentOption(
                        'assets/images/dana.png', 'Dana', deviceWidth, deviceHeight),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (showQRIS)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset('assets/images/qris.png', height: 300),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          height: 125,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: _navigateToScanner,
                    ),
                    Text('Scanner', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.black,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.qr_code_2),
                      onPressed: () {
                        setState(() {
                          showQRIS = !showQRIS;
                        });
                      },
                    ),
                    Text('QRIS Tampil', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String imagePath, String paymentName,
      double deviceWidth, double deviceHeight) {
    return Container(
      width: deviceWidth * 0.4,
      height: deviceHeight * 0.2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 50),
          Text(paymentName, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (result != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'QR Code Data: ${result!.code}',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
